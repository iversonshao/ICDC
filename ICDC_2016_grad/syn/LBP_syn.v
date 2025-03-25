/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP2
// Date      : Tue Mar 25 14:30:15 2025
/////////////////////////////////////////////////////////////


module LBP_DW01_inc_0_DW01_inc_1 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;

  wire   [6:2] carry;

  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  CLKINVX1 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[6]), .B(A[6]), .Y(SUM[6]) );
endmodule


module LBP_DW01_inc_1_DW01_inc_2 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;

  wire   [6:2] carry;

  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  CLKINVX1 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[6]), .B(A[6]), .Y(SUM[6]) );
endmodule


module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, 
        lbp_valid, lbp_data, finish );
  output [13:0] gray_addr;
  input [7:0] gray_data;
  output [13:0] lbp_addr;
  output [7:0] lbp_data;
  input clk, reset, gray_ready;
  output gray_req, lbp_valid, finish;
  wire   n406, n407, n408, n409, n410, n411, n412, n413, n414, n415, n416,
         n417, n418, n419, n420, n421, n422, n423, n424, n425, n426, n427,
         n428, n429, n430, n431, n432, n433, n434, n435, n436, n437, n438,
         n439, n440, n441, n442, N82, N110, N111, N112, N113, N114, N115, N116,
         N117, N118, N119, N120, N121, N122, N123, N157, N159, N160, N161,
         N162, N163, N164, N165, N166, n9, n10, n11, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n27, n29, n31, n48, n49, n50, n51, n52, n53,
         n55, n56, n58, n59, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71,
         n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n127, n128, n129, n130, n131, n132, n133, n134,
         n135, n136, n137, n138, n139, n140, n142, n143, n144, n145, n146,
         n147, n149, n150, n151, n153, n154, n155, n156, n157, n158, n159,
         n160, n161, n162, n163, n164, n165, n166, n167, n168, n169, n170,
         n171, n172, n173, n174, n175, n176, n177, n178, n179, n180, n181,
         n182, n183, n184, n185, n186, n187, n188, n189, n190, n191, n192,
         n193, n194, n195, n196, n197, n198, n199, n200, n201, n202, n203,
         n204, n205, n206, n207, n208, n209, n210, n211, n212, n213, n214,
         n215, \sll_165/SH[0] , n447, n448, n328, n329, n330, n331, n332, n333,
         n334, n335, n336, n337, n338, n339, n340, n341, n342, n343, n344,
         n345, n346, n347, n348, n349, n350, n351, n352, n353, n354, n355,
         n356, n357, n358, n359, n360, n361, n362, n363, n364, n365, n366,
         n367, n368, n369, n370, n371, n372, n373, n374, n375, n376, n377,
         n378, n379, n380, n381, n382, n383, n384, n385, n386, n387, n388,
         n389, n390, n391, n392, n393, n394, n395, n396, n397, n398, n399,
         n400, n401, n402, n403, n404, n405, n443, n445;
  wire   [6:0] x_b;
  wire   [6:0] x_f;
  wire   [6:0] y_b;
  wire   [6:0] y_f;
  wire   [6:0] g1_addr;
  wire   [13:7] g3_addr;
  wire   [3:0] counter;
  wire   [3:0] counter_minus_one;
  wire   [2:0] state;
  wire   [2:0] next_state;
  wire   [7:0] gc_data;

  DFFRX1 \y_reg[6]  ( .D(n185), .CK(clk), .RN(n346), .Q(g3_addr[13]), .QN(n120) );
  DFFRX1 \y_reg[5]  ( .D(n187), .CK(clk), .RN(n346), .Q(g3_addr[12]), .QN(n122) );
  DFFRX1 \y_reg[4]  ( .D(n189), .CK(clk), .RN(n346), .Q(g3_addr[11]), .QN(n116) );
  DFFSX1 \gc_addr_reg[0]  ( .D(n215), .CK(clk), .SN(n351), .QN(n102) );
  DFFSX1 \gc_addr_reg[7]  ( .D(n194), .CK(clk), .SN(n351), .QN(n111) );
  DFFRX1 \y_reg[3]  ( .D(n191), .CK(clk), .RN(n346), .Q(g3_addr[10]), .QN(n114) );
  DFFRX1 \y_reg[2]  ( .D(n193), .CK(clk), .RN(n346), .Q(g3_addr[9]), .QN(n112)
         );
  DFFRX1 \y_reg[1]  ( .D(n197), .CK(clk), .RN(n346), .Q(g3_addr[8]), .QN(n108)
         );
  DFFRX1 \counter_reg[1]  ( .D(n214), .CK(clk), .RN(n347), .Q(counter[1]), 
        .QN(n151) );
  DFFSX1 \y_reg[0]  ( .D(n195), .CK(clk), .SN(n351), .Q(g3_addr[7]), .QN(
        y_b[0]) );
  DFFSX1 \x_reg[0]  ( .D(n208), .CK(clk), .SN(n351), .Q(g1_addr[0]), .QN(
        x_b[0]) );
  DFFRX1 \counter_reg[2]  ( .D(n212), .CK(clk), .RN(n347), .Q(counter[2]), 
        .QN(n150) );
  DFFRX1 \counter_reg[0]  ( .D(n213), .CK(clk), .RN(n347), .Q(counter[0]), 
        .QN(\sll_165/SH[0] ) );
  DFFRX1 \x_reg[2]  ( .D(n207), .CK(clk), .RN(n346), .Q(g1_addr[2]), .QN(n146)
         );
  DFFRX1 \x_reg[6]  ( .D(n199), .CK(clk), .RN(n347), .Q(g1_addr[6]), .QN(n142)
         );
  DFFRX1 \x_reg[5]  ( .D(n201), .CK(clk), .RN(n347), .Q(g1_addr[5]), .QN(n143)
         );
  DFFRX1 \x_reg[4]  ( .D(n203), .CK(clk), .RN(n347), .Q(g1_addr[4]), .QN(n144)
         );
  DFFRX1 \x_reg[3]  ( .D(n205), .CK(clk), .RN(n346), .Q(g1_addr[3]), .QN(n145)
         );
  DFFRX1 \x_reg[1]  ( .D(n210), .CK(clk), .RN(n346), .Q(g1_addr[1]), .QN(n147)
         );
  DFFRX1 \gray_addr_reg[0]  ( .D(n138), .CK(clk), .RN(n349), .Q(n419), .QN(n79) );
  DFFRX1 \gray_addr_reg[6]  ( .D(n132), .CK(clk), .RN(n349), .Q(n413), .QN(n73) );
  DFFRX1 finish_reg ( .D(n125), .CK(clk), .RN(n348), .Q(n442), .QN(n124) );
  DFFRX1 \gray_addr_reg[1]  ( .D(n137), .CK(clk), .RN(n349), .Q(n418), .QN(n78) );
  DFFRX1 \gray_addr_reg[2]  ( .D(n136), .CK(clk), .RN(n349), .Q(n417), .QN(n77) );
  DFFRX1 \gray_addr_reg[3]  ( .D(n135), .CK(clk), .RN(n349), .Q(n416), .QN(n76) );
  DFFRX1 \lbp_data_reg[0]  ( .D(n161), .CK(clk), .RN(n351), .Q(n441), .QN(n94)
         );
  DFFRX1 \lbp_data_reg[1]  ( .D(n160), .CK(clk), .RN(n351), .Q(n440), .QN(n95)
         );
  DFFRX1 \lbp_data_reg[2]  ( .D(n159), .CK(clk), .RN(n351), .Q(n439), .QN(n96)
         );
  DFFRX1 \lbp_data_reg[3]  ( .D(n158), .CK(clk), .RN(n351), .Q(n438), .QN(n97)
         );
  DFFRX1 \lbp_data_reg[4]  ( .D(n157), .CK(clk), .RN(n351), .Q(n437), .QN(n98)
         );
  DFFRX1 \lbp_data_reg[5]  ( .D(n156), .CK(clk), .RN(n351), .Q(n436), .QN(n99)
         );
  DFFRX1 \lbp_data_reg[6]  ( .D(n155), .CK(clk), .RN(n385), .Q(n435), .QN(n100) );
  DFFRX1 \lbp_data_reg[7]  ( .D(n154), .CK(clk), .RN(n385), .Q(n434), .QN(n101) );
  DFFRX1 \lbp_addr_reg[0]  ( .D(n170), .CK(clk), .RN(n385), .Q(n433), .QN(n93)
         );
  DFFRX1 \lbp_addr_reg[1]  ( .D(n171), .CK(clk), .RN(n385), .Q(n432), .QN(n92)
         );
  DFFRX1 \lbp_addr_reg[2]  ( .D(n172), .CK(clk), .RN(n350), .Q(n431), .QN(n91)
         );
  DFFRX1 \lbp_addr_reg[3]  ( .D(n173), .CK(clk), .RN(n350), .Q(n430), .QN(n90)
         );
  DFFRX1 \lbp_addr_reg[4]  ( .D(n174), .CK(clk), .RN(n350), .Q(n429), .QN(n89)
         );
  DFFRX1 \lbp_addr_reg[5]  ( .D(n175), .CK(clk), .RN(n350), .Q(n428), .QN(n88)
         );
  DFFRX1 \lbp_addr_reg[6]  ( .D(n176), .CK(clk), .RN(n350), .Q(n427), .QN(n87)
         );
  DFFRX1 \lbp_addr_reg[7]  ( .D(n177), .CK(clk), .RN(n350), .Q(n426), .QN(n86)
         );
  DFFRX1 \lbp_addr_reg[8]  ( .D(n178), .CK(clk), .RN(n350), .Q(n425), .QN(n85)
         );
  DFFRX1 \lbp_addr_reg[9]  ( .D(n179), .CK(clk), .RN(n350), .Q(n424), .QN(n84)
         );
  DFFRX1 \lbp_addr_reg[10]  ( .D(n180), .CK(clk), .RN(n350), .Q(n423), .QN(n83) );
  DFFRX1 \lbp_addr_reg[11]  ( .D(n181), .CK(clk), .RN(n350), .Q(n422), .QN(n82) );
  DFFRX1 \lbp_addr_reg[12]  ( .D(n182), .CK(clk), .RN(n350), .Q(n421), .QN(n81) );
  DFFRX1 \lbp_addr_reg[13]  ( .D(n183), .CK(clk), .RN(n350), .Q(n420), .QN(n80) );
  DFFRX1 \gray_addr_reg[4]  ( .D(n134), .CK(clk), .RN(n349), .Q(n415), .QN(n75) );
  DFFRX1 \gray_addr_reg[5]  ( .D(n133), .CK(clk), .RN(n349), .Q(n414), .QN(n74) );
  DFFRX1 \gray_addr_reg[7]  ( .D(n131), .CK(clk), .RN(n349), .Q(n412), .QN(n72) );
  DFFRX1 \gray_addr_reg[13]  ( .D(n139), .CK(clk), .RN(n348), .Q(n406), .QN(
        n121) );
  DFFRX1 \gray_addr_reg[8]  ( .D(n130), .CK(clk), .RN(n349), .Q(n411), .QN(n71) );
  DFFRX1 \gray_addr_reg[9]  ( .D(n129), .CK(clk), .RN(n349), .Q(n410), .QN(n70) );
  DFFRX1 \gray_addr_reg[10]  ( .D(n128), .CK(clk), .RN(n349), .Q(n409), .QN(
        n69) );
  DFFRX1 \gray_addr_reg[11]  ( .D(n127), .CK(clk), .RN(n349), .Q(n408), .QN(
        n68) );
  DFFRX1 \gray_addr_reg[12]  ( .D(n140), .CK(clk), .RN(n348), .Q(n407), .QN(
        n123) );
  DFFRX1 \state_reg[2]  ( .D(next_state[2]), .CK(clk), .RN(n385), .Q(state[2]), 
        .QN(n392) );
  DFFRX1 \state_reg[1]  ( .D(n390), .CK(clk), .RN(n385), .Q(state[1]), .QN(
        n394) );
  DFFRX1 \gc_data_reg[0]  ( .D(n162), .CK(clk), .RN(n385), .Q(gc_data[0]), 
        .QN(n379) );
  DFFRX1 \gc_data_reg[7]  ( .D(n169), .CK(clk), .RN(n385), .Q(gc_data[7]) );
  DFFRX1 \gc_data_reg[5]  ( .D(n167), .CK(clk), .RN(n385), .Q(gc_data[5]) );
  DFFRX1 \gc_data_reg[3]  ( .D(n165), .CK(clk), .RN(n385), .Q(gc_data[3]) );
  DFFRX1 \gc_data_reg[1]  ( .D(n163), .CK(clk), .RN(n385), .Q(gc_data[1]) );
  DFFRX1 \gc_data_reg[4]  ( .D(n166), .CK(clk), .RN(n385), .Q(gc_data[4]) );
  DFFRX1 \gc_data_reg[2]  ( .D(n164), .CK(clk), .RN(n385), .Q(gc_data[2]) );
  DFFRX1 \gc_data_reg[6]  ( .D(n168), .CK(clk), .RN(n385), .Q(gc_data[6]), 
        .QN(n380) );
  DFFRX1 \state_reg[0]  ( .D(next_state[0]), .CK(clk), .RN(n385), .Q(state[0]), 
        .QN(n393) );
  NOR2X2 U221 ( .A(n343), .B(n387), .Y(n16) );
  OAI211X1 U222 ( .A0(n389), .A1(n10), .B0(n62), .C0(n63), .Y(next_state[0])
         );
  INVX6 U225 ( .A(reset), .Y(n385) );
  BUFX12 U226 ( .A(n407), .Y(gray_addr[12]) );
  BUFX12 U227 ( .A(n408), .Y(gray_addr[11]) );
  BUFX12 U228 ( .A(n409), .Y(gray_addr[10]) );
  BUFX12 U229 ( .A(n410), .Y(gray_addr[9]) );
  BUFX12 U230 ( .A(n411), .Y(gray_addr[8]) );
  BUFX12 U231 ( .A(n406), .Y(gray_addr[13]) );
  BUFX12 U232 ( .A(n412), .Y(gray_addr[7]) );
  NOR2BX2 U233 ( .AN(n329), .B(n341), .Y(n332) );
  NOR2BX2 U234 ( .AN(n335), .B(n339), .Y(n336) );
  OAI32X4 U235 ( .A0(n341), .A1(counter[2]), .A2(n340), .B0(counter[1]), .B1(
        n330), .Y(n331) );
  NOR2BX2 U236 ( .AN(n334), .B(counter[2]), .Y(n337) );
  OAI32X4 U237 ( .A0(n341), .A1(counter[1]), .A2(n339), .B0(n330), .B1(n340), 
        .Y(n333) );
  BUFX12 U238 ( .A(n414), .Y(gray_addr[5]) );
  BUFX12 U239 ( .A(n415), .Y(gray_addr[4]) );
  BUFX12 U240 ( .A(n420), .Y(lbp_addr[13]) );
  BUFX12 U241 ( .A(n421), .Y(lbp_addr[12]) );
  BUFX12 U242 ( .A(n422), .Y(lbp_addr[11]) );
  BUFX12 U243 ( .A(n423), .Y(lbp_addr[10]) );
  BUFX12 U244 ( .A(n424), .Y(lbp_addr[9]) );
  BUFX12 U245 ( .A(n425), .Y(lbp_addr[8]) );
  BUFX12 U246 ( .A(n426), .Y(lbp_addr[7]) );
  BUFX12 U247 ( .A(n427), .Y(lbp_addr[6]) );
  BUFX12 U248 ( .A(n428), .Y(lbp_addr[5]) );
  BUFX12 U249 ( .A(n429), .Y(lbp_addr[4]) );
  BUFX12 U250 ( .A(n430), .Y(lbp_addr[3]) );
  BUFX12 U251 ( .A(n431), .Y(lbp_addr[2]) );
  BUFX12 U252 ( .A(n432), .Y(lbp_addr[1]) );
  BUFX12 U253 ( .A(n433), .Y(lbp_addr[0]) );
  BUFX12 U254 ( .A(n434), .Y(lbp_data[7]) );
  BUFX12 U255 ( .A(n435), .Y(lbp_data[6]) );
  BUFX12 U256 ( .A(n436), .Y(lbp_data[5]) );
  BUFX12 U257 ( .A(n437), .Y(lbp_data[4]) );
  BUFX12 U258 ( .A(n438), .Y(lbp_data[3]) );
  BUFX12 U259 ( .A(n439), .Y(lbp_data[2]) );
  BUFX12 U260 ( .A(n440), .Y(lbp_data[1]) );
  BUFX12 U261 ( .A(n441), .Y(lbp_data[0]) );
  BUFX12 U262 ( .A(n416), .Y(gray_addr[3]) );
  BUFX12 U263 ( .A(n417), .Y(gray_addr[2]) );
  BUFX12 U264 ( .A(n418), .Y(gray_addr[1]) );
  BUFX12 U265 ( .A(n442), .Y(finish) );
  BUFX12 U266 ( .A(n413), .Y(gray_addr[6]) );
  BUFX12 U267 ( .A(n419), .Y(gray_addr[0]) );
  OAI22X2 U268 ( .A0(n335), .A1(n339), .B0(counter[2]), .B1(n334), .Y(n338) );
  BUFX4 U269 ( .A(n19), .Y(n343) );
  NOR2XL U270 ( .A(n56), .B(next_state[0]), .Y(n48) );
  AND2X1 U271 ( .A(next_state[0]), .B(n56), .Y(n328) );
  OAI211XL U272 ( .A0(x_b[0]), .A1(n15), .B0(n17), .C0(n18), .Y(n208) );
  NAND4BBXL U273 ( .AN(n147), .BN(n146), .C(n20), .D(n21), .Y(n17) );
  OAI21XL U274 ( .A0(n149), .A1(n395), .B0(n53), .Y(counter_minus_one[3]) );
  OAI21XL U275 ( .A0(n150), .A1(n58), .B0(n59), .Y(counter_minus_one[2]) );
  CLKINVX1 U276 ( .A(n151), .Y(n398) );
  CLKBUFX3 U277 ( .A(N82), .Y(n342) );
  NAND2X1 U278 ( .A(n353), .B(n388), .Y(N82) );
  INVX3 U279 ( .A(n354), .Y(n353) );
  INVX3 U280 ( .A(n354), .Y(n352) );
  OR2X1 U281 ( .A(n16), .B(n387), .Y(n15) );
  INVX3 U282 ( .A(n48), .Y(n388) );
  CLKBUFX3 U283 ( .A(n328), .Y(n354) );
  CLKBUFX3 U284 ( .A(n386), .Y(n345) );
  CLKINVX1 U285 ( .A(n343), .Y(n386) );
  CLKINVX1 U286 ( .A(n56), .Y(n390) );
  CLKINVX1 U287 ( .A(counter_minus_one[1]), .Y(n396) );
  CLKBUFX3 U288 ( .A(n348), .Y(n350) );
  CLKBUFX3 U289 ( .A(n348), .Y(n349) );
  CLKBUFX3 U290 ( .A(n385), .Y(n348) );
  CLKBUFX3 U291 ( .A(n385), .Y(n347) );
  CLKBUFX3 U292 ( .A(n385), .Y(n346) );
  NOR2BX2 U293 ( .AN(n51), .B(n52), .Y(n50) );
  NOR2X2 U294 ( .A(n51), .B(n52), .Y(n49) );
  INVX3 U295 ( .A(n17), .Y(n387) );
  NAND2X1 U296 ( .A(n390), .B(next_state[0]), .Y(n19) );
  OA21XL U297 ( .A0(n397), .A1(n388), .B0(n31), .Y(n29) );
  OA21XL U298 ( .A0(n398), .A1(n388), .B0(n29), .Y(n27) );
  NAND2X1 U299 ( .A(n388), .B(n10), .Y(n31) );
  CLKINVX1 U300 ( .A(n330), .Y(n341) );
  NOR2X1 U301 ( .A(n51), .B(n391), .Y(n56) );
  INVX3 U302 ( .A(n55), .Y(n391) );
  CLKINVX1 U303 ( .A(n59), .Y(n395) );
  OAI21X1 U304 ( .A0(n397), .A1(n398), .B0(n23), .Y(counter_minus_one[1]) );
  NAND2X1 U305 ( .A(n397), .B(n398), .Y(n23) );
  NAND2X1 U306 ( .A(n397), .B(n396), .Y(n401) );
  NAND2X1 U307 ( .A(counter_minus_one[1]), .B(n397), .Y(n403) );
  OR2X1 U308 ( .A(counter_minus_one[2]), .B(counter_minus_one[3]), .Y(n400) );
  NAND2BX1 U309 ( .AN(counter_minus_one[3]), .B(counter_minus_one[2]), .Y(n405) );
  OAI21XL U310 ( .A0(n9), .A1(n10), .B0(n11), .Y(next_state[2]) );
  CLKBUFX3 U311 ( .A(n385), .Y(n351) );
  AOI31X1 U312 ( .A0(N157), .A1(n53), .A2(n51), .B0(n391), .Y(n52) );
  CLKINVX1 U313 ( .A(gray_data[7]), .Y(n384) );
  OAI2BB2XL U314 ( .B0(n94), .B1(n49), .A0N(N159), .A1N(n50), .Y(n161) );
  NOR2X1 U315 ( .A(n401), .B(n400), .Y(N159) );
  OAI2BB2XL U316 ( .B0(n95), .B1(n49), .A0N(N160), .A1N(n50), .Y(n160) );
  NOR2X1 U317 ( .A(n402), .B(n400), .Y(N160) );
  OAI2BB2XL U318 ( .B0(n96), .B1(n49), .A0N(N161), .A1N(n50), .Y(n159) );
  NOR2X1 U319 ( .A(n403), .B(n400), .Y(N161) );
  OAI2BB2XL U320 ( .B0(n97), .B1(n49), .A0N(N162), .A1N(n50), .Y(n158) );
  NOR2X1 U321 ( .A(n404), .B(n400), .Y(N162) );
  OAI2BB2XL U322 ( .B0(n98), .B1(n49), .A0N(N163), .A1N(n50), .Y(n157) );
  NOR2X1 U323 ( .A(n405), .B(n401), .Y(N163) );
  OAI2BB2XL U324 ( .B0(n99), .B1(n49), .A0N(N164), .A1N(n50), .Y(n156) );
  NOR2X1 U325 ( .A(n405), .B(n402), .Y(N164) );
  OAI2BB2XL U326 ( .B0(n100), .B1(n49), .A0N(N165), .A1N(n50), .Y(n155) );
  NOR2X1 U327 ( .A(n405), .B(n403), .Y(N165) );
  OAI2BB2XL U328 ( .B0(n101), .B1(n49), .A0N(N166), .A1N(n50), .Y(n154) );
  NOR2X1 U329 ( .A(n405), .B(n404), .Y(N166) );
  CLKINVX1 U330 ( .A(gray_data[1]), .Y(n381) );
  CLKINVX1 U331 ( .A(gray_data[5]), .Y(n383) );
  CLKINVX1 U332 ( .A(gray_data[3]), .Y(n382) );
  NAND3BX1 U333 ( .AN(n149), .B(n395), .C(n51), .Y(n62) );
  CLKINVX1 U334 ( .A(n9), .Y(n389) );
  NAND4X1 U335 ( .A(gray_ready), .B(n393), .C(n394), .D(n392), .Y(n63) );
  NOR4X1 U336 ( .A(n142), .B(n143), .C(n144), .D(n145), .Y(n21) );
  NOR2BX1 U337 ( .AN(x_b[0]), .B(n343), .Y(n20) );
  NAND2X1 U338 ( .A(x_f[0]), .B(n16), .Y(n18) );
  OAI2BB2XL U339 ( .B0(n145), .B1(n15), .A0N(x_f[3]), .A1N(n16), .Y(n205) );
  OAI2BB2XL U340 ( .B0(n144), .B1(n15), .A0N(x_f[4]), .A1N(n16), .Y(n203) );
  OAI2BB2XL U341 ( .B0(n143), .B1(n15), .A0N(x_f[5]), .A1N(n16), .Y(n201) );
  OAI2BB2XL U342 ( .B0(n142), .B1(n15), .A0N(x_f[6]), .A1N(n16), .Y(n199) );
  OAI2BB2XL U343 ( .B0(n146), .B1(n15), .A0N(x_f[2]), .A1N(n16), .Y(n207) );
  OAI2BB2XL U344 ( .B0(n147), .B1(n15), .A0N(x_f[1]), .A1N(n16), .Y(n210) );
  OAI32X1 U345 ( .A0(n344), .A1(n150), .A2(n23), .B0(n149), .B1(n24), .Y(n211)
         );
  OA21XL U346 ( .A0(n399), .A1(n388), .B0(n27), .Y(n24) );
  OAI32X1 U347 ( .A0(n23), .A1(n399), .A2(n388), .B0(n150), .B1(n27), .Y(n212)
         );
  OAI222XL U348 ( .A0(y_b[0]), .A1(n353), .B0(n344), .B1(N117), .C0(n72), .C1(
        n342), .Y(n131) );
  OAI222XL U349 ( .A0(n108), .A1(n353), .B0(n344), .B1(N118), .C0(n71), .C1(
        n342), .Y(n130) );
  OAI222XL U350 ( .A0(n112), .A1(n352), .B0(n344), .B1(N119), .C0(n70), .C1(
        n342), .Y(n129) );
  OAI222XL U351 ( .A0(n114), .A1(n352), .B0(n344), .B1(N120), .C0(n69), .C1(
        n342), .Y(n128) );
  OAI222XL U352 ( .A0(n116), .A1(n353), .B0(n344), .B1(N121), .C0(n68), .C1(
        n342), .Y(n127) );
  OAI222XL U353 ( .A0(n122), .A1(n353), .B0(n344), .B1(N122), .C0(n123), .C1(
        n342), .Y(n140) );
  OAI222XL U354 ( .A0(n120), .A1(n353), .B0(n344), .B1(N123), .C0(n121), .C1(
        n342), .Y(n139) );
  OAI222XL U355 ( .A0(x_b[0]), .A1(n353), .B0(n344), .B1(N110), .C0(n79), .C1(
        n342), .Y(n138) );
  OAI222XL U356 ( .A0(n147), .A1(n353), .B0(n344), .B1(N111), .C0(n78), .C1(
        n342), .Y(n137) );
  OAI222XL U357 ( .A0(n146), .A1(n353), .B0(n344), .B1(N112), .C0(n77), .C1(
        n342), .Y(n136) );
  OAI222XL U358 ( .A0(n145), .A1(n353), .B0(n344), .B1(N113), .C0(n76), .C1(
        n342), .Y(n135) );
  OAI222XL U359 ( .A0(n144), .A1(n353), .B0(n344), .B1(N114), .C0(n75), .C1(
        n342), .Y(n134) );
  OAI222XL U360 ( .A0(n143), .A1(n353), .B0(n344), .B1(N115), .C0(n74), .C1(
        n342), .Y(n133) );
  OAI222XL U361 ( .A0(n142), .A1(n353), .B0(n344), .B1(N116), .C0(n73), .C1(
        n342), .Y(n132) );
  OAI2BB2XL U362 ( .B0(n120), .B1(n387), .A0N(y_f[6]), .A1N(n387), .Y(n185) );
  OAI2BB2XL U363 ( .B0(n122), .B1(n387), .A0N(y_f[5]), .A1N(n387), .Y(n187) );
  OAI2BB2XL U364 ( .B0(n116), .B1(n387), .A0N(y_f[4]), .A1N(n387), .Y(n189) );
  OAI2BB2XL U365 ( .B0(n114), .B1(n387), .A0N(y_f[3]), .A1N(n387), .Y(n191) );
  OAI2BB2XL U366 ( .B0(n112), .B1(n387), .A0N(y_f[2]), .A1N(n387), .Y(n193) );
  OAI2BB2XL U367 ( .B0(n108), .B1(n387), .A0N(y_f[1]), .A1N(n387), .Y(n197) );
  OAI2BB2XL U368 ( .B0(y_b[0]), .B1(n387), .A0N(y_f[0]), .A1N(n387), .Y(n195)
         );
  OAI32X1 U369 ( .A0(n388), .A1(\sll_165/SH[0] ), .A2(n398), .B0(n151), .B1(
        n29), .Y(n214) );
  CLKBUFX3 U370 ( .A(n22), .Y(n344) );
  NAND2X1 U371 ( .A(n149), .B(n48), .Y(n22) );
  OAI22XL U372 ( .A0(n102), .A1(n343), .B0(n93), .B1(n345), .Y(n170) );
  OAI22XL U373 ( .A0(n103), .A1(n343), .B0(n92), .B1(n345), .Y(n171) );
  OAI22XL U374 ( .A0(n104), .A1(n343), .B0(n91), .B1(n345), .Y(n172) );
  OAI22XL U375 ( .A0(n105), .A1(n343), .B0(n90), .B1(n345), .Y(n173) );
  OAI22XL U376 ( .A0(n106), .A1(n343), .B0(n89), .B1(n345), .Y(n174) );
  OAI22XL U377 ( .A0(n107), .A1(n343), .B0(n88), .B1(n345), .Y(n175) );
  OAI22XL U378 ( .A0(n153), .A1(n343), .B0(n87), .B1(n345), .Y(n176) );
  OAI22XL U379 ( .A0(n111), .A1(n343), .B0(n86), .B1(n345), .Y(n177) );
  OAI22XL U380 ( .A0(n109), .A1(n343), .B0(n85), .B1(n345), .Y(n178) );
  OAI22XL U381 ( .A0(n113), .A1(n343), .B0(n84), .B1(n345), .Y(n179) );
  OAI22XL U382 ( .A0(n115), .A1(n343), .B0(n83), .B1(n345), .Y(n180) );
  OAI22XL U383 ( .A0(n117), .A1(n343), .B0(n82), .B1(n345), .Y(n181) );
  OAI22XL U384 ( .A0(n118), .A1(n343), .B0(n81), .B1(n345), .Y(n182) );
  OAI22XL U385 ( .A0(n119), .A1(n343), .B0(n80), .B1(n345), .Y(n183) );
  OAI22XL U386 ( .A0(n147), .A1(n353), .B0(n103), .B1(n328), .Y(n209) );
  OAI22XL U387 ( .A0(n146), .A1(n352), .B0(n104), .B1(n354), .Y(n206) );
  OAI22XL U388 ( .A0(n145), .A1(n352), .B0(n105), .B1(n328), .Y(n204) );
  OAI22XL U389 ( .A0(n144), .A1(n352), .B0(n106), .B1(n354), .Y(n202) );
  OAI22XL U390 ( .A0(n114), .A1(n352), .B0(n115), .B1(n354), .Y(n190) );
  OAI22XL U391 ( .A0(n116), .A1(n352), .B0(n117), .B1(n354), .Y(n188) );
  OAI22XL U392 ( .A0(n122), .A1(n352), .B0(n118), .B1(n328), .Y(n186) );
  OAI22XL U393 ( .A0(n120), .A1(n352), .B0(n119), .B1(n328), .Y(n184) );
  OAI22XL U394 ( .A0(n143), .A1(n352), .B0(n107), .B1(n328), .Y(n200) );
  OAI22XL U395 ( .A0(n108), .A1(n352), .B0(n109), .B1(n354), .Y(n196) );
  OAI22XL U396 ( .A0(n112), .A1(n352), .B0(n113), .B1(n354), .Y(n192) );
  OAI22XL U397 ( .A0(n142), .A1(n352), .B0(n153), .B1(n328), .Y(n198) );
  OAI22XL U398 ( .A0(n397), .A1(n388), .B0(\sll_165/SH[0] ), .B1(n31), .Y(n213) );
  OAI22XL U399 ( .A0(x_b[0]), .A1(n353), .B0(n102), .B1(n354), .Y(n215) );
  OAI22XL U400 ( .A0(y_b[0]), .A1(n352), .B0(n111), .B1(n354), .Y(n194) );
  AO22X1 U401 ( .A0(gray_data[6]), .A1(n391), .B0(n55), .B1(gc_data[6]), .Y(
        n168) );
  AO22X1 U402 ( .A0(gray_data[2]), .A1(n391), .B0(n55), .B1(gc_data[2]), .Y(
        n164) );
  AO22X1 U403 ( .A0(gray_data[4]), .A1(n391), .B0(n55), .B1(gc_data[4]), .Y(
        n166) );
  AO22X1 U404 ( .A0(gray_data[1]), .A1(n391), .B0(n55), .B1(gc_data[1]), .Y(
        n163) );
  AO22X1 U405 ( .A0(gray_data[3]), .A1(n391), .B0(n55), .B1(gc_data[3]), .Y(
        n165) );
  AO22X1 U406 ( .A0(gray_data[5]), .A1(n391), .B0(n55), .B1(gc_data[5]), .Y(
        n167) );
  AO22X1 U407 ( .A0(gray_data[7]), .A1(n391), .B0(n55), .B1(gc_data[7]), .Y(
        n169) );
  AO22X1 U408 ( .A0(gray_data[0]), .A1(n391), .B0(n55), .B1(gc_data[0]), .Y(
        n162) );
  CLKINVX1 U409 ( .A(counter[1]), .Y(n340) );
  CLKINVX1 U410 ( .A(counter[2]), .Y(n339) );
  NAND3X1 U411 ( .A(state[0]), .B(n392), .C(state[1]), .Y(n10) );
  NAND4BX1 U412 ( .AN(n64), .B(n65), .C(n66), .D(n67), .Y(n9) );
  NOR3X1 U413 ( .A(n113), .B(n107), .C(n109), .Y(n66) );
  NOR4X1 U414 ( .A(n115), .B(n117), .C(n118), .D(n119), .Y(n65) );
  NOR4X1 U415 ( .A(n103), .B(n104), .C(n105), .D(n106), .Y(n67) );
  NAND3BX1 U416 ( .AN(n153), .B(n102), .C(n111), .Y(n64) );
  NOR3X2 U417 ( .A(state[0]), .B(state[2]), .C(n394), .Y(n51) );
  NAND3X2 U418 ( .A(n394), .B(n392), .C(state[0]), .Y(n55) );
  NAND3X1 U419 ( .A(n151), .B(\sll_165/SH[0] ), .C(n150), .Y(n59) );
  NAND2X1 U420 ( .A(n149), .B(n395), .Y(n53) );
  INVX3 U421 ( .A(\sll_165/SH[0] ), .Y(n397) );
  NAND2X1 U422 ( .A(\sll_165/SH[0] ), .B(n396), .Y(n402) );
  NOR2X1 U423 ( .A(n397), .B(n398), .Y(n58) );
  NAND2X1 U424 ( .A(counter_minus_one[1]), .B(\sll_165/SH[0] ), .Y(n404) );
  CLKINVX1 U425 ( .A(n150), .Y(n399) );
  NAND3X1 U426 ( .A(n393), .B(n394), .C(state[2]), .Y(n11) );
  NAND2X1 U427 ( .A(n124), .B(n11), .Y(n125) );
  XOR2X1 U428 ( .A(counter[0]), .B(counter[2]), .Y(n330) );
  XOR2X1 U429 ( .A(n340), .B(counter[2]), .Y(n329) );
  AOI222XL U430 ( .A0(x_f[0]), .A1(n333), .B0(g1_addr[0]), .B1(n332), .C0(
        x_b[0]), .C1(n331), .Y(N110) );
  AOI222XL U431 ( .A0(x_f[1]), .A1(n333), .B0(g1_addr[1]), .B1(n332), .C0(
        x_b[1]), .C1(n331), .Y(N111) );
  AOI222XL U432 ( .A0(x_f[2]), .A1(n333), .B0(g1_addr[2]), .B1(n332), .C0(
        x_b[2]), .C1(n331), .Y(N112) );
  AOI222XL U433 ( .A0(x_f[3]), .A1(n333), .B0(g1_addr[3]), .B1(n332), .C0(
        x_b[3]), .C1(n331), .Y(N113) );
  AOI222XL U434 ( .A0(x_f[4]), .A1(n333), .B0(g1_addr[4]), .B1(n332), .C0(
        x_b[4]), .C1(n331), .Y(N114) );
  AOI222XL U435 ( .A0(x_f[5]), .A1(n333), .B0(g1_addr[5]), .B1(n332), .C0(
        x_b[5]), .C1(n331), .Y(N115) );
  AOI222XL U436 ( .A0(x_f[6]), .A1(n333), .B0(g1_addr[6]), .B1(n332), .C0(
        x_b[6]), .C1(n331), .Y(N116) );
  NAND2BX1 U437 ( .AN(counter[0]), .B(n340), .Y(n335) );
  NAND2X1 U438 ( .A(counter[1]), .B(counter[0]), .Y(n334) );
  AOI222XL U439 ( .A0(g3_addr[7]), .A1(n338), .B0(y_b[0]), .B1(n337), .C0(
        y_f[0]), .C1(n336), .Y(N117) );
  AOI222XL U440 ( .A0(g3_addr[8]), .A1(n338), .B0(y_b[1]), .B1(n337), .C0(
        y_f[1]), .C1(n336), .Y(N118) );
  AOI222XL U441 ( .A0(g3_addr[9]), .A1(n338), .B0(y_b[2]), .B1(n337), .C0(
        y_f[2]), .C1(n336), .Y(N119) );
  AOI222XL U442 ( .A0(g3_addr[10]), .A1(n338), .B0(y_b[3]), .B1(n337), .C0(
        y_f[3]), .C1(n336), .Y(N120) );
  AOI222XL U443 ( .A0(g3_addr[11]), .A1(n338), .B0(y_b[4]), .B1(n337), .C0(
        y_f[4]), .C1(n336), .Y(N121) );
  AOI222XL U444 ( .A0(g3_addr[12]), .A1(n338), .B0(y_b[5]), .B1(n337), .C0(
        y_f[5]), .C1(n336), .Y(N122) );
  AOI222XL U445 ( .A0(g3_addr[13]), .A1(n338), .B0(y_b[6]), .B1(n337), .C0(
        y_f[6]), .C1(n336), .Y(N123) );
  NAND2BX1 U446 ( .AN(g1_addr[1]), .B(x_b[0]), .Y(n355) );
  OAI2BB1X1 U447 ( .A0N(g1_addr[0]), .A1N(g1_addr[1]), .B0(n355), .Y(x_b[1])
         );
  OR2X1 U448 ( .A(n355), .B(g1_addr[2]), .Y(n356) );
  OAI2BB1X1 U449 ( .A0N(n355), .A1N(g1_addr[2]), .B0(n356), .Y(x_b[2]) );
  NOR2X1 U450 ( .A(n356), .B(g1_addr[3]), .Y(n357) );
  AO21X1 U451 ( .A0(n356), .A1(g1_addr[3]), .B0(n357), .Y(x_b[3]) );
  NAND2X1 U452 ( .A(n357), .B(n144), .Y(n358) );
  OAI21XL U453 ( .A0(n357), .A1(n144), .B0(n358), .Y(x_b[4]) );
  XNOR2X1 U454 ( .A(g1_addr[5]), .B(n358), .Y(x_b[5]) );
  NOR2X1 U455 ( .A(g1_addr[5]), .B(n358), .Y(n359) );
  XOR2X1 U456 ( .A(g1_addr[6]), .B(n359), .Y(x_b[6]) );
  NAND2BX1 U457 ( .AN(g3_addr[8]), .B(y_b[0]), .Y(n360) );
  OAI2BB1X1 U458 ( .A0N(g3_addr[7]), .A1N(g3_addr[8]), .B0(n360), .Y(y_b[1])
         );
  OR2X1 U459 ( .A(n360), .B(g3_addr[9]), .Y(n361) );
  OAI2BB1X1 U460 ( .A0N(n360), .A1N(g3_addr[9]), .B0(n361), .Y(y_b[2]) );
  NOR2X1 U461 ( .A(n361), .B(g3_addr[10]), .Y(n362) );
  AO21X1 U462 ( .A0(n361), .A1(g3_addr[10]), .B0(n362), .Y(y_b[3]) );
  NAND2X1 U463 ( .A(n362), .B(n116), .Y(n363) );
  OAI21XL U464 ( .A0(n362), .A1(n116), .B0(n363), .Y(y_b[4]) );
  XNOR2X1 U465 ( .A(g3_addr[12]), .B(n363), .Y(y_b[5]) );
  NOR2X1 U466 ( .A(g3_addr[12]), .B(n363), .Y(n364) );
  XOR2X1 U467 ( .A(g3_addr[13]), .B(n364), .Y(y_b[6]) );
  NAND2BX1 U468 ( .AN(gc_data[4]), .B(gray_data[4]), .Y(n365) );
  OAI222XL U469 ( .A0(gc_data[5]), .A1(n383), .B0(gc_data[5]), .B1(n365), .C0(
        n383), .C1(n365), .Y(n366) );
  OAI222XL U470 ( .A0(gray_data[6]), .A1(n366), .B0(n380), .B1(n366), .C0(
        gray_data[6]), .C1(n380), .Y(n377) );
  NOR2BX1 U471 ( .AN(gc_data[4]), .B(gray_data[4]), .Y(n367) );
  OAI22XL U472 ( .A0(n367), .A1(n383), .B0(gc_data[5]), .B1(n367), .Y(n375) );
  NAND2BX1 U473 ( .AN(gc_data[2]), .B(gray_data[2]), .Y(n373) );
  OAI2BB2XL U474 ( .B0(gray_data[0]), .B1(n379), .A0N(n381), .A1N(gc_data[1]), 
        .Y(n368) );
  OAI21XL U475 ( .A0(gc_data[1]), .A1(n381), .B0(n368), .Y(n371) );
  NOR2BX1 U476 ( .AN(gc_data[2]), .B(gray_data[2]), .Y(n369) );
  OAI22XL U477 ( .A0(n369), .A1(n382), .B0(gc_data[3]), .B1(n369), .Y(n370) );
  AOI2BB2X1 U478 ( .B0(n371), .B1(n370), .A0N(n373), .A1N(n382), .Y(n372) );
  OAI221XL U479 ( .A0(gc_data[3]), .A1(n373), .B0(gc_data[3]), .B1(n382), .C0(
        n372), .Y(n374) );
  OAI211X1 U480 ( .A0(gray_data[6]), .A1(n380), .B0(n375), .C0(n374), .Y(n376)
         );
  AO22X1 U481 ( .A0(n384), .A1(gc_data[7]), .B0(n377), .B1(n376), .Y(n378) );
  OAI21XL U482 ( .A0(gc_data[7]), .A1(n384), .B0(n378), .Y(N157) );
  LBP_DW01_inc_0_DW01_inc_1 r394 ( .A(g3_addr), .SUM(y_f) );
  LBP_DW01_inc_1_DW01_inc_2 r392 ( .A(g1_addr), .SUM(x_f) );
  DFFRX1 lbp_valid_reg ( .D(n345), .CK(clk), .RN(n385), .Q(n448) );
  DFFRX1 gray_req_reg ( .D(N82), .CK(clk), .RN(n385), .Q(n447) );
  DFFRX1 \gc_addr_reg[11]  ( .D(n188), .CK(clk), .RN(n385), .QN(n117) );
  DFFRX1 \gc_addr_reg[10]  ( .D(n190), .CK(clk), .RN(n385), .QN(n115) );
  DFFRX1 \gc_addr_reg[9]  ( .D(n192), .CK(clk), .RN(n385), .QN(n113) );
  DFFRX1 \gc_addr_reg[8]  ( .D(n196), .CK(clk), .RN(n385), .QN(n109) );
  DFFRX1 \gc_addr_reg[4]  ( .D(n202), .CK(clk), .RN(n385), .QN(n106) );
  DFFRX1 \gc_addr_reg[2]  ( .D(n206), .CK(clk), .RN(n385), .QN(n104) );
  DFFRX1 \gc_addr_reg[13]  ( .D(n184), .CK(clk), .RN(n385), .QN(n119) );
  DFFRX1 \gc_addr_reg[12]  ( .D(n186), .CK(clk), .RN(n385), .QN(n118) );
  DFFRX1 \gc_addr_reg[6]  ( .D(n198), .CK(clk), .RN(n385), .QN(n153) );
  DFFRX1 \gc_addr_reg[5]  ( .D(n200), .CK(clk), .RN(n385), .QN(n107) );
  DFFRX1 \gc_addr_reg[3]  ( .D(n204), .CK(clk), .RN(n385), .QN(n105) );
  DFFRX1 \gc_addr_reg[1]  ( .D(n209), .CK(clk), .RN(n385), .QN(n103) );
  DFFRX1 \counter_reg[3]  ( .D(n211), .CK(clk), .RN(n385), .QN(n149) );
  INVXL U223 ( .A(n447), .Y(n443) );
  INVX12 U224 ( .A(n443), .Y(gray_req) );
  INVXL U483 ( .A(n448), .Y(n445) );
  INVX12 U484 ( .A(n445), .Y(lbp_valid) );
endmodule

