import argparse
import os
from typing import List, Type, Tuple
from librelane.steps import Step, OpenROADStep, Yosys, Misc, OpenROAD, Odb, Checker, Magic, Netgen, KLayout, Verilator
from librelane.steps.step import ViewsUpdate, MetricsUpdate
from librelane.flows import Flow, FlowError
from librelane.flows.sequential import SequentialFlow
from librelane.state.state import State
from librelane.config.variable import Variable
from librelane.config.config import Config
from librelane.logging import info
from decimal import Decimal
from librelane.common import Path
from typing import (
    Any,
    List,
    Dict,
    Literal,
    Set,
    Tuple,
    Optional,
    Union,
)



# Custom step definition to be completed ...



# Custom flow definition to be completed ...



# For IIC-OSIC-TOOLS container make OpenROAD-Librelane the default OpenROAD.
os.environ["PATH"] = "/tmp/librelane-bin:" + os.environ["PATH"]


def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Start the custom librelane flow")
    # Argument for the config file path, defaulting to "config.yaml"
    parser.add_argument(
        "config_path",
        nargs="?",
        default="config.yaml",
        help="Path to the config YAML file to use for the flow",
    )
    start_options = parser.add_mutually_exclusive_group()
    # Optional argument to start the flow from a previous run
    start_options.add_argument(
        "--last-run",
        action="store_true",
        help="Resume the most recent flow run",
    )
    # Optional argument to start the flow using a specific run tag
    start_options.add_argument(
        "--run-tag",
        metavar="TAG",
        help="Start a flow run using the specified tag",
    )
    # Optional argument to set the flow initial state (can be used to start in the middle of an old run)
    parser.add_argument(
        "-i",
        dest="initial_state_path",
        metavar="PATH",
        help="Start from the state loaded from PATH",
    )
    args = parser.parse_args()


    # Initialize custom flow with basic parameters
    flow = CustomStepFlow(
        args.config_path,
        pdk_root   = "/foss/pdks",
        design_dir = ".",
    )


    initial_state = (
        State.loads(Path(args.initial_state_path).read_text())
        if args.initial_state_path is not None
        else None
    )

    if initial_state is not None:
        if args.last_run:
            flow.start(last_run=True, with_initial_state=initial_state)
        elif args.run_tag is not None:
            flow.start(tag=args.run_tag, with_initial_state=initial_state)
        else:
            flow.start(with_initial_state=initial_state)
    elif args.last_run:
        flow.start(last_run=True)
    elif args.run_tag is not None:
        flow.start(tag=args.run_tag)
    else:
        flow.start()


if __name__ == "__main__":
    main()