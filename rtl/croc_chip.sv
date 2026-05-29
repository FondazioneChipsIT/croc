// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Authors:
// - Philippe Sauter <phsauter@iis.ee.ethz.ch>

module croc_chip import croc_pkg::*; #() (
  input  wire clk_i,
  input  wire rst_ni,
  input  wire ref_clk_i,

  input  wire jtag_tck_i,
  input  wire jtag_trst_ni,
  input  wire jtag_tms_i,
  input  wire jtag_tdi_i,
  output wire jtag_tdo_o,

  input  wire uart_rx_i,
  output wire uart_tx_o,

  input  wire testmode_i,
  output wire status_o,

  inout  wire gpio0_io,
  inout  wire gpio1_io,
  inout  wire gpio2_io,
  inout  wire gpio3_io,
  inout  wire gpio4_io,
  inout  wire gpio5_io,
  inout  wire gpio6_io,
  inout  wire gpio7_io,
  inout  wire gpio8_io,
  inout  wire gpio9_io,
  inout  wire gpio10_io,
  inout  wire gpio11_io,
  inout  wire gpio12_io,
  inout  wire gpio13_io,
  inout  wire gpio14_io,
  inout  wire gpio15_io,
  inout  wire gpio16_io,
  inout  wire gpio17_io,
  inout  wire gpio18_io,
  inout  wire gpio19_io,
  inout  wire gpio20_io,
  inout  wire gpio21_io,
  inout  wire gpio22_io,
  inout  wire gpio23_io,
  inout  wire gpio24_io,
  inout  wire gpio25_io,
  inout  wire gpio26_io,
  inout  wire gpio27_io,
  inout  wire gpio28_io,
  inout  wire gpio29_io,
  inout  wire gpio30_io,
  inout  wire gpio31_io,
  output wire unused0_o,
  output wire unused1_o,
  output wire unused2_o,
  output wire unused3_o,

  inout wire VDD,
  inout wire VSS,
  inout wire VDDIO,
  inout wire VSSIO
);
    logic soc_clk_i;
    logic soc_rst_ni;
    logic soc_ref_clk_i;
    logic soc_testmode_i;

    logic soc_jtag_tck_i;
    logic soc_jtag_trst_ni;
    logic soc_jtag_tms_i;
    logic soc_jtag_tdi_i;
    logic soc_jtag_tdo_o;

    logic soc_status_o;

    localparam int unsigned GpioCount = 32;

    logic [GpioCount-1:0] soc_gpio_i;
    logic [GpioCount-1:0] soc_gpio_o;
    logic [GpioCount-1:0] soc_gpio_out_en_o; // Output enable signal; 0 -> input, 1 -> output

    sg13g2_IOPadIn        pad_clk_i        (       
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.p2c(soc_clk_i),
    	.pad(clk_i)
    );
    sg13g2_IOPadIn        pad_rst_ni       (       
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.p2c(soc_rst_ni),
    	.pad(rst_ni)
    );
    sg13g2_IOPadIn        pad_ref_clk_i    (    
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.p2c(soc_ref_clk_i),
    	.pad(ref_clk_i)
    );
    sg13g2_IOPadIn        pad_jtag_tck_i   (   
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.p2c(soc_jtag_tck_i),
    	.pad(jtag_tck_i)
    );
    sg13g2_IOPadIn        pad_jtag_trst_ni ( 
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.p2c(soc_jtag_trst_ni),
    	.pad(jtag_trst_ni)
    );
    sg13g2_IOPadIn        pad_jtag_tms_i   ( 
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.p2c(soc_jtag_tms_i),
    	.pad(jtag_tms_i)
    );
    sg13g2_IOPadIn        pad_jtag_tdi_i   (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.p2c(soc_jtag_tdi_i),
    	.pad(jtag_tdi_i)
    );
    sg13g2_IOPadOut16mA   pad_jtag_tdo_o   (  
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p(soc_jtag_tdo_o),
    	.pad(jtag_tdo_o)
    );

    sg13g2_IOPadIn        pad_uart_rx_i    ( 
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.p2c(soc_uart_rx_i),
    	.pad(uart_rx_i)
    );
    sg13g2_IOPadOut16mA   pad_uart_tx_o    (  
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p(soc_uart_tx_o),
    	.pad(uart_tx_o)
    );

    sg13g2_IOPadIn        pad_testmode_i   ( 
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.p2c(soc_testmode_i),
    	.pad(testmode_i)
    );
    sg13g2_IOPadOut16mA   pad_status_o     (  
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p(soc_status_o),
    	.pad(status_o)
    );

    sg13g2_IOPadInOut30mA pad_gpio0_io     (  
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[0]),
    	.p2c(soc_gpio_i[0]), 
    	.c2p(soc_gpio_o[0]), 
    	.pad(gpio0_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio1_io     (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[1]),
    	.p2c(soc_gpio_i[1]), 
    	.c2p(soc_gpio_o[1]), 
    	.pad(gpio1_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio2_io     (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[2]),
    	.p2c(soc_gpio_i[2]), 
    	.c2p(soc_gpio_o[2]), 
    	.pad(gpio2_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio3_io     (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[3]),
    	.p2c(soc_gpio_i[3]), 
    	.c2p(soc_gpio_o[3]), 
    	.pad(gpio3_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio4_io     (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[4]),
    	.p2c(soc_gpio_i[4]), 
    	.c2p(soc_gpio_o[4]), 
    	.pad(gpio4_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio5_io     (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[5]),
    	.p2c(soc_gpio_i[5]), 
    	.c2p(soc_gpio_o[5]), 
    	.pad(gpio5_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio6_io     (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[6]),
    	.p2c(soc_gpio_i[6]), 
    	.c2p(soc_gpio_o[6]), 
    	.pad(gpio6_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio7_io     (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[7]),
    	.p2c(soc_gpio_i[7]), 
    	.c2p(soc_gpio_o[7]), 
    	.pad(gpio7_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio8_io     (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[8]),
    	.p2c(soc_gpio_i[8]), 
    	.c2p(soc_gpio_o[8]), 
    	.pad(gpio8_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio9_io     (      
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[9]),
    	.p2c(soc_gpio_i[9]),
    	.c2p(soc_gpio_o[9]),
    	.pad(gpio9_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio10_io    ( 
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[10]),
    	.p2c(soc_gpio_i[10]), 
    	.c2p(soc_gpio_o[10]),
    	.pad(gpio10_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio11_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[11]),
    	.p2c(soc_gpio_i[11]), 
    	.c2p(soc_gpio_o[11]),
    	.pad(gpio11_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio12_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[12]),
    	.p2c(soc_gpio_i[12]), 
    	.c2p(soc_gpio_o[12]),
    	.pad(gpio12_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio13_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[13]),
    	.p2c(soc_gpio_i[13]), 
    	.c2p(soc_gpio_o[13]),
    	.pad(gpio13_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio14_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[14]),
    	.p2c(soc_gpio_i[14]), 
    	.c2p(soc_gpio_o[14]),
    	.pad(gpio14_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio15_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[15]),
    	.p2c(soc_gpio_i[15]), 
    	.c2p(soc_gpio_o[15]),
    	.pad(gpio15_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio16_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[16]),
    	.p2c(soc_gpio_i[16]), 
    	.c2p(soc_gpio_o[16]),
    	.pad(gpio16_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio17_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[17]),
    	.p2c(soc_gpio_i[17]), 
    	.c2p(soc_gpio_o[17]),
    	.pad(gpio17_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio18_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[18]),
    	.p2c(soc_gpio_i[18]), 
    	.c2p(soc_gpio_o[18]),
    	.pad(gpio18_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio19_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[19]),
    	.p2c(soc_gpio_i[19]), 
    	.c2p(soc_gpio_o[19]),
    	.pad(gpio19_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio20_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[20]),
    	.p2c(soc_gpio_i[20]), 
    	.c2p(soc_gpio_o[20]),
    	.pad(gpio20_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio21_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[21]),
    	.p2c(soc_gpio_i[21]), 
    	.c2p(soc_gpio_o[21]),
    	.pad(gpio21_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio22_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[22]),
    	.p2c(soc_gpio_i[22]), 
    	.c2p(soc_gpio_o[22]),
    	.pad(gpio22_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio23_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[23]),
    	.p2c(soc_gpio_i[23]), 
    	.c2p(soc_gpio_o[23]),
    	.pad(gpio23_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio24_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[24]),
    	.p2c(soc_gpio_i[24]), 
    	.c2p(soc_gpio_o[24]),
    	.pad(gpio24_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio25_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[25]),
    	.p2c(soc_gpio_i[25]), 
    	.c2p(soc_gpio_o[25]),
    	.pad(gpio25_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio26_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[26]),
    	.p2c(soc_gpio_i[26]), 
    	.c2p(soc_gpio_o[26]),
    	.pad(gpio26_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio27_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[27]),
    	.p2c(soc_gpio_i[27]), 
    	.c2p(soc_gpio_o[27]),
    	.pad(gpio27_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio28_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[28]),
    	.p2c(soc_gpio_i[28]), 
    	.c2p(soc_gpio_o[28]),
    	.pad(gpio28_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio29_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[29]),
    	.p2c(soc_gpio_i[29]), 
    	.c2p(soc_gpio_o[29]),
    	.pad(gpio29_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio30_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[30]),
    	.p2c(soc_gpio_i[30]), 
    	.c2p(soc_gpio_o[30]),
    	.pad(gpio30_io)
    );
    sg13g2_IOPadInOut30mA pad_gpio31_io    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p_en(soc_gpio_out_en_o[31]),
    	.p2c(soc_gpio_i[31]), 
    	.c2p(soc_gpio_o[31]),
    	.pad(gpio31_io)
    );
    sg13g2_IOPadOut16mA   pad_unused0_o    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p(soc_status_o),
    	.pad(unused0_o)
    );
    sg13g2_IOPadOut16mA   pad_unused1_o    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p(soc_status_o),
    	.pad(unused1_o)
    );
    sg13g2_IOPadOut16mA   pad_unused2_o    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p(soc_status_o),
    	.pad(unused2_o)
    );
    sg13g2_IOPadOut16mA   pad_unused3_o    (
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS),
    	`endif
    	.c2p(soc_status_o),
    	.pad(unused3_o)
    );

    (* keep *)sg13g2_IOPadVdd pad_vdd0(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadVdd pad_vdd1(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadVdd pad_vdd2(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadVdd pad_vdd3(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );

    (* keep *)sg13g2_IOPadVss pad_vss0(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadVss pad_vss1(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadVss pad_vss2(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadVss pad_vss3(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );

    (* keep *)sg13g2_IOPadIOVdd pad_vddio0(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadIOVdd pad_vddio1(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadIOVdd pad_vddio2(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadIOVdd pad_vddio3(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );

    (* keep *)sg13g2_IOPadIOVss pad_vssio0(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadIOVss pad_vssio1(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadIOVss pad_vssio2(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );
    (* keep *)sg13g2_IOPadIOVss pad_vssio3(
    	`ifdef USE_POWER_PINS
        .iovdd  (VDDIO),
        .iovss  (VSSIO),
        .vdd    (VDD),
        .vss    (VSS)
        `endif
    );

  croc_soc #(
    .GpioCount( GpioCount )
  )
  i_croc_soc (
    .clk_i          ( soc_clk_i      ),
    .rst_ni         ( soc_rst_ni     ),
    .ref_clk_i      ( soc_ref_clk_i  ),
    .testmode_i     ( soc_testmode_i ),
    .status_o       ( soc_status_o   ),

    .jtag_tck_i     ( soc_jtag_tck_i   ),
    .jtag_tdi_i     ( soc_jtag_tdi_i   ),
    .jtag_tdo_o     ( soc_jtag_tdo_o   ),
    .jtag_tms_i     ( soc_jtag_tms_i   ),
    .jtag_trst_ni   ( soc_jtag_trst_ni ),

    .uart_rx_i      ( soc_uart_rx_i ),
    .uart_tx_o      ( soc_uart_tx_o ),

    .gpio_i         ( soc_gpio_i        ),
    .gpio_o         ( soc_gpio_o        ),
    .gpio_out_en_o  ( soc_gpio_out_en_o )
  );

endmodule
