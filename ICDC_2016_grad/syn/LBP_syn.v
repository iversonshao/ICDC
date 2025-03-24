/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP2
// Date      : Sun Mar 23 00:28:36 2025
/////////////////////////////////////////////////////////////


module LBP_DW01_inc_0_DW01_inc_1 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(SUM[7]), .S(SUM[6]) );
  CLKINVX1 U1 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module LBP_DW01_inc_1_DW01_inc_2 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;

  wire   [6:2] carry;

  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
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
  wire   n802, n803, n804, n805, n806, n807, n808, n809, n810, n811, n812,
         n813, n814, n815, n816, n817, n818, n819, n820, n821, n822, n823,
         n824, \pixel_buffer[0][6] , \pixel_buffer[0][5] ,
         \pixel_buffer[0][4] , \pixel_buffer[0][3] , \pixel_buffer[0][2] ,
         \pixel_buffer[0][1] , \pixel_buffer[0][0] , \pixel_buffer[1][6] ,
         \pixel_buffer[1][5] , \pixel_buffer[1][4] , \pixel_buffer[1][3] ,
         \pixel_buffer[1][2] , \pixel_buffer[1][1] , \pixel_buffer[1][0] ,
         \pixel_buffer[2][6] , \pixel_buffer[2][5] , \pixel_buffer[2][4] ,
         \pixel_buffer[2][3] , \pixel_buffer[2][2] , \pixel_buffer[2][1] ,
         \pixel_buffer[2][0] , \pixel_buffer[3][6] , \pixel_buffer[3][5] ,
         \pixel_buffer[3][4] , \pixel_buffer[3][3] , \pixel_buffer[3][2] ,
         \pixel_buffer[3][1] , \pixel_buffer[3][0] , \pixel_buffer[4][7] ,
         \pixel_buffer[4][6] , \pixel_buffer[4][5] , \pixel_buffer[4][4] ,
         \pixel_buffer[4][3] , \pixel_buffer[4][2] , \pixel_buffer[4][1] ,
         \pixel_buffer[4][0] , \pixel_buffer[5][6] , \pixel_buffer[5][5] ,
         \pixel_buffer[5][4] , \pixel_buffer[5][3] , \pixel_buffer[5][1] ,
         \pixel_buffer[5][0] , \pixel_buffer[6][6] , \pixel_buffer[6][5] ,
         \pixel_buffer[6][4] , \pixel_buffer[6][3] , \pixel_buffer[6][1] ,
         \pixel_buffer[6][0] , \pixel_buffer[7][6] , \pixel_buffer[7][5] ,
         \pixel_buffer[7][4] , \pixel_buffer[7][3] , \pixel_buffer[7][1] ,
         \pixel_buffer[7][0] , N136, N138, N139, N140, N141, N142, N143, N144,
         N145, N146, N147, N148, N149, N150, N158, N159, N160, N161, N162,
         N163, N164, N165, N166, N167, N168, N169, N170, N171, N186, N187,
         N188, N189, N190, N191, N192, N193, N194, N195, N196, N197, N198,
         N199, N200, N216, N217, N218, N219, N220, N221, N222, N230, N231,
         N232, N233, N234, N235, N236, N252, N253, N254, N255, N256, N257,
         N258, N281, N282, N283, N284, N285, N286, N287, N302, N303, N304,
         N305, N306, N307, N308, N331, N332, N333, N334, N335, N336, N337,
         N417, N443, n214, n215, n216, n217, n218, n219, n220, n221, n222,
         n223, n224, n225, n226, n227, n228, n229, n230, n231, n232, n233,
         n234, n235, n236, n237, n238, n239, n240, n241, n242, n243, n244,
         n245, n246, n247, n248, n249, n250, n251, n252, n253, n254, n255,
         n256, n257, n258, n259, n260, n261, n262, n263, n264, n265, n266,
         n267, n268, n269, n270, n271, n272, n273, n274, n275, n276, n277,
         n278, n279, n280, n281, n282, n283, n284, n285, n286, n287, n288,
         n289, n290, n291, n292, n293, n294, n295, n296, n297, n298, n299,
         n300, n301, n302, n303, n304, n305, n306, n307, n308, n309, n310,
         n311, n312, n313, n314, n315, n316, n317, n318, n319, n320, n321,
         n322, n323, n324, n325, n326, n327, n328, n329, n330, n331, n332,
         n333, n334, n335, n336, n337, n338, n339, n340, n342, n343, n344,
         n345, n346, n347, n348, n349, n872, n871, n857, n858, n859, n860,
         n861, n862, n863, n864, n865, n866, n867, n868, n869, n870, n404,
         n405, n406, n407, n408, n409, n410, n411, n412, n413, n414, n415,
         n416, n417, n418, n419, n420, n421, n422, n423, n424, n425, n426,
         n427, n428, n429, n430, n431, n432, n433, n434, n435, n436, n437,
         n438, n439, n440, n441, n442, n443, n444, n445, n446, n447, n448,
         n449, n450, n451, n452, n453, n454, n455, n456, n457, n458, n459,
         n460, n461, n462, n463, n464, n465, n466, n467, n468, n469, n470,
         n471, n472, n473, n474, n475, n476, n477, n478, n479, n480, n481,
         n482, n483, n484, n485, n486, n487, n488, n489, n490, n491, n492,
         n493, n494, n495, n496, n497, n498, n499, n500, n501, n502, n503,
         n504, n505, n506, n507, n508, n509, n510, n511, n512, n513, n514,
         n515, n516, n517, n518, n519, n520, n521, n522, n523, n524, n525,
         n526, n527, n528, n529, n530, n531, n532, n533, n534, n535, n536,
         n537, n538, n539, n540, n541, n542, n543, n544, n545, n546, n547,
         n548, n549, n550, n551, n552, n553, n554, n555, n556, n557, n558,
         n559, n560, n561, n562, n563, n564, n565, n566, n567, n568, n569,
         n570, n571, n572, n573, n574, n575, n576, n577, n578, n579, n580,
         n581, n582, n583, n584, n585, n586, n587, n588, n589, n590, n591,
         n592, n593, n594, n595, n596, n597, n598, n599, n600, n601, n602,
         n603, n604, n605, n606, n607, n608, n609, n610, n611, n612, n613,
         n614, n615, n616, n617, n618, n619, n620, n621, n622, n623, n624,
         n625, n626, n627, n628, n629, n630, n631, n632, n633, n634, n635,
         n636, n637, n638, n639, n640, n641, n642, n643, n644, n645, n646,
         n647, n648, n649, n650, n651, n652, n653, n654, n655, n656, n657,
         n658, n659, n660, n661, n662, n663, n664, n665, n666, n667, n668,
         n669, n670, n671, n672, n673, n674, n675, n676, n677, n678, n679,
         n680, n681, n682, n683, n684, n685, n686, n687, n688, n689, n690,
         n691, n692, n693, n694, n695, n696, n697, n698, n699, n700, n701,
         n702, n703, n704, n705, n706, n707, n708, n709, n710, n711, n712,
         n713, n714, n715, n716, n717, n718, n719, n720, n721, n722, n723,
         n724, n725, n726, n727, n728, n729, n730, n731, n732, n733, n734,
         n735, n736, n737, n738, n739, n740, n741, n742, n743, n744, n745,
         n746, n747, n748, n749, n750, n751, n752, n753, n754, n755, n756,
         n757, n758, n759, n760, n761, n762, n763, n764, n765, n766, n767,
         n768, n769, n770, n771, n772, n773, n774, n775, n776, n777, n778,
         n779, n780, n781, n782, n783, n784, n785, n786, n787, n788, n789,
         n790, n791, n792, n793, n794, n795, n796, n797, n798, n799, n800,
         n801, n825, n827, n829, n831, n833, n835, n837, n839, n841, n843,
         n845, n847, n849, n851, n853, n855;
  wire   [2:0] state;
  wire   [2:0] next_state;
  wire   [3:0] read_count;
  wire   [13:1] \add_107/carry ;
  wire   [13:1] \add_110_2/carry ;
  wire   [13:1] \add_104/carry ;

  DFFRX1 \lbp_result_reg[0]  ( .D(n253), .CK(clk), .RN(n444), .Q(n615), .QN(
        n796) );
  DFFRX1 \lbp_result_reg[1]  ( .D(n252), .CK(clk), .RN(n444), .Q(n633), .QN(
        n794) );
  DFFRX1 \lbp_result_reg[2]  ( .D(n251), .CK(clk), .RN(n444), .Q(n648), .QN(
        n792) );
  DFFRX1 \lbp_result_reg[3]  ( .D(n250), .CK(clk), .RN(n444), .Q(n663), .QN(
        n790) );
  DFFRX1 \lbp_result_reg[7]  ( .D(n249), .CK(clk), .RN(n445), .Q(n678), .QN(
        n785) );
  DFFRX1 \lbp_result_reg[4]  ( .D(n240), .CK(clk), .RN(n445), .Q(n699), .QN(
        n800) );
  DFFRX1 \lbp_result_reg[5]  ( .D(n231), .CK(clk), .RN(n446), .Q(n720), .QN(
        n799) );
  DFFRX1 \lbp_result_reg[6]  ( .D(n222), .CK(clk), .RN(n447), .Q(n741), .QN(
        n798) );
  DFFSX1 \row_reg[0]  ( .D(n340), .CK(clk), .SN(n447), .Q(N230), .QN(n349) );
  DFFRX1 \gray_addr_reg[0]  ( .D(n307), .CK(clk), .RN(n801), .Q(n870) );
  DFFRX1 \gray_addr_reg[1]  ( .D(n306), .CK(clk), .RN(n443), .Q(n869) );
  DFFRX1 \gray_addr_reg[2]  ( .D(n305), .CK(clk), .RN(n443), .Q(n868) );
  DFFRX1 \gray_addr_reg[3]  ( .D(n304), .CK(clk), .RN(n443), .Q(n867) );
  DFFRX1 \gray_addr_reg[4]  ( .D(n303), .CK(clk), .RN(n443), .Q(n866) );
  DFFRX1 \gray_addr_reg[5]  ( .D(n302), .CK(clk), .RN(n443), .Q(n865) );
  DFFRX1 \gray_addr_reg[6]  ( .D(n301), .CK(clk), .RN(n443), .Q(n864) );
  DFFRX1 \gray_addr_reg[7]  ( .D(n300), .CK(clk), .RN(n443), .Q(n863) );
  DFFRX1 \gray_addr_reg[8]  ( .D(n299), .CK(clk), .RN(n443), .Q(n862) );
  DFFRX1 \gray_addr_reg[9]  ( .D(n298), .CK(clk), .RN(n443), .Q(n861) );
  DFFRX1 \gray_addr_reg[10]  ( .D(n297), .CK(clk), .RN(n443), .Q(n860) );
  DFFRX1 \gray_addr_reg[11]  ( .D(n296), .CK(clk), .RN(n443), .Q(n859) );
  DFFRX1 \gray_addr_reg[12]  ( .D(n295), .CK(clk), .RN(n443), .Q(n858) );
  DFFRX1 \gray_addr_reg[13]  ( .D(n294), .CK(clk), .RN(n442), .Q(n857) );
  DFFRX1 gray_req_reg ( .D(N443), .CK(clk), .RN(n447), .Q(n871) );
  DFFRX1 \lbp_data_reg[6]  ( .D(n215), .CK(clk), .RN(n447), .Q(n817), .QN(n787) );
  DFFRX1 \lbp_data_reg[5]  ( .D(n216), .CK(clk), .RN(n446), .Q(n818), .QN(n788) );
  DFFRX1 \lbp_data_reg[4]  ( .D(n217), .CK(clk), .RN(n446), .Q(n819), .QN(n789) );
  DFFRX1 \lbp_data_reg[7]  ( .D(n214), .CK(clk), .RN(n445), .Q(n816), .QN(n786) );
  DFFRX1 \lbp_data_reg[3]  ( .D(n218), .CK(clk), .RN(n445), .Q(n820), .QN(n791) );
  DFFRX1 \lbp_data_reg[2]  ( .D(n219), .CK(clk), .RN(n444), .Q(n821), .QN(n793) );
  DFFRX1 \lbp_data_reg[1]  ( .D(n220), .CK(clk), .RN(n444), .Q(n822), .QN(n795) );
  DFFRX1 \lbp_data_reg[0]  ( .D(n221), .CK(clk), .RN(n444), .Q(n823), .QN(n797) );
  DFFRX1 finish_reg ( .D(n339), .CK(clk), .RN(n442), .Q(n824), .QN(n784) );
  DFFRX1 \lbp_addr_reg[13]  ( .D(n308), .CK(clk), .RN(n442), .Q(n802), .QN(
        n770) );
  DFFRX1 \lbp_addr_reg[12]  ( .D(n309), .CK(clk), .RN(n442), .Q(n803), .QN(
        n771) );
  DFFRX1 \lbp_addr_reg[11]  ( .D(n310), .CK(clk), .RN(n442), .Q(n804), .QN(
        n772) );
  DFFRX1 \lbp_addr_reg[10]  ( .D(n311), .CK(clk), .RN(n442), .Q(n805), .QN(
        n773) );
  DFFRX1 \lbp_addr_reg[9]  ( .D(n312), .CK(clk), .RN(n441), .Q(n806), .QN(n774) );
  DFFRX1 \lbp_addr_reg[8]  ( .D(n313), .CK(clk), .RN(n441), .Q(n807), .QN(n775) );
  DFFRX1 \lbp_addr_reg[7]  ( .D(n314), .CK(clk), .RN(n441), .Q(n808), .QN(n776) );
  DFFRX1 \lbp_addr_reg[6]  ( .D(n315), .CK(clk), .RN(n441), .Q(n809), .QN(n777) );
  DFFRX1 \lbp_addr_reg[5]  ( .D(n316), .CK(clk), .RN(n441), .Q(n810), .QN(n778) );
  DFFRX1 \lbp_addr_reg[4]  ( .D(n317), .CK(clk), .RN(n441), .Q(n811), .QN(n779) );
  DFFRX1 \lbp_addr_reg[3]  ( .D(n318), .CK(clk), .RN(n441), .Q(n812), .QN(n780) );
  DFFRX1 \lbp_addr_reg[2]  ( .D(n319), .CK(clk), .RN(n441), .Q(n813), .QN(n781) );
  DFFRX1 \lbp_addr_reg[1]  ( .D(n320), .CK(clk), .RN(n441), .Q(n814), .QN(n782) );
  DFFRX1 \lbp_addr_reg[0]  ( .D(n321), .CK(clk), .RN(n441), .Q(n815), .QN(n783) );
  DFFRX1 \col_reg[1]  ( .D(n337), .CK(clk), .RN(n801), .Q(N159), .QN(n493) );
  DFFRX1 \col_reg[3]  ( .D(n335), .CK(clk), .RN(n801), .Q(N161), .QN(n495) );
  DFFRX1 \col_reg[2]  ( .D(n336), .CK(clk), .RN(n801), .Q(N160), .QN(n494) );
  DFFRX1 \state_reg[2]  ( .D(next_state[2]), .CK(clk), .RN(n801), .Q(state[2])
         );
  DFFRX1 \row_reg[6]  ( .D(n326), .CK(clk), .RN(n801), .Q(N236), .QN(n499) );
  DFFRXL \pixel_buffer_reg[4][0]  ( .D(n254), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[4][0] ) );
  DFFRXL \pixel_buffer_reg[6][4]  ( .D(n236), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[6][4] ) );
  DFFRXL \pixel_buffer_reg[7][4]  ( .D(n227), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[7][4] ) );
  DFFRXL \pixel_buffer_reg[5][4]  ( .D(n245), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[5][4] ) );
  DFFRXL \pixel_buffer_reg[6][5]  ( .D(n237), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[6][5] ) );
  DFFRXL \pixel_buffer_reg[7][5]  ( .D(n228), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[7][5] ) );
  DFFRXL \pixel_buffer_reg[5][5]  ( .D(n246), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[5][5] ) );
  DFFRXL \pixel_buffer_reg[4][2]  ( .D(n256), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[4][2] ) );
  DFFRXL \pixel_buffer_reg[2][2]  ( .D(n272), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[2][2] ) );
  DFFRXL \pixel_buffer_reg[1][2]  ( .D(n280), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[1][2] ) );
  DFFRXL \pixel_buffer_reg[0][2]  ( .D(n288), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[0][2] ) );
  DFFRXL \pixel_buffer_reg[3][2]  ( .D(n264), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[3][2] ) );
  DFFRXL \pixel_buffer_reg[6][1]  ( .D(n233), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[6][1] ) );
  DFFRXL \pixel_buffer_reg[7][1]  ( .D(n224), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[7][1] ) );
  DFFRXL \pixel_buffer_reg[5][1]  ( .D(n242), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[5][1] ) );
  DFFRXL \pixel_buffer_reg[4][1]  ( .D(n255), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[4][1] ) );
  DFFRXL \pixel_buffer_reg[2][1]  ( .D(n271), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[2][1] ) );
  DFFRXL \pixel_buffer_reg[1][1]  ( .D(n279), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[1][1] ) );
  DFFRXL \pixel_buffer_reg[0][1]  ( .D(n287), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[0][1] ) );
  DFFRXL \pixel_buffer_reg[3][1]  ( .D(n263), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[3][1] ) );
  DFFRXL \pixel_buffer_reg[6][3]  ( .D(n235), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[6][3] ) );
  DFFRXL \pixel_buffer_reg[7][3]  ( .D(n226), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[7][3] ) );
  DFFRXL \pixel_buffer_reg[5][3]  ( .D(n244), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[5][3] ) );
  DFFRXL \pixel_buffer_reg[2][3]  ( .D(n273), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[2][3] ) );
  DFFRXL \pixel_buffer_reg[1][3]  ( .D(n281), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[1][3] ) );
  DFFRXL \pixel_buffer_reg[0][3]  ( .D(n289), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[0][3] ) );
  DFFRXL \pixel_buffer_reg[3][3]  ( .D(n265), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[3][3] ) );
  DFFRXL \pixel_buffer_reg[6][7]  ( .D(n239), .CK(clk), .RN(n801), .QN(n714)
         );
  DFFRXL \pixel_buffer_reg[7][7]  ( .D(n230), .CK(clk), .RN(n801), .QN(n735)
         );
  DFFRXL \pixel_buffer_reg[5][7]  ( .D(n248), .CK(clk), .RN(n801), .QN(n693)
         );
  DFFRXL \pixel_buffer_reg[2][7]  ( .D(n277), .CK(clk), .RN(n801), .QN(n595)
         );
  DFFRXL \pixel_buffer_reg[1][7]  ( .D(n285), .CK(clk), .RN(n801), .QN(n590)
         );
  DFFRXL \pixel_buffer_reg[0][7]  ( .D(n293), .CK(clk), .RN(n801), .QN(n580)
         );
  DFFRXL \pixel_buffer_reg[3][7]  ( .D(n269), .CK(clk), .RN(n801), .QN(n601)
         );
  DFFRXL \pixel_buffer_reg[6][2]  ( .D(n234), .CK(clk), .RN(n801), .QN(n717)
         );
  DFFRXL \pixel_buffer_reg[7][2]  ( .D(n225), .CK(clk), .RN(n801), .QN(n738)
         );
  DFFRXL \pixel_buffer_reg[5][2]  ( .D(n243), .CK(clk), .RN(n801), .QN(n696)
         );
  DFFRX1 lbp_valid_reg ( .D(n451), .CK(clk), .RN(n801), .Q(n872) );
  DFFRX1 \read_count_reg[1]  ( .D(n323), .CK(clk), .RN(n801), .Q(read_count[1]), .QN(n487) );
  DFFRX1 \read_count_reg[2]  ( .D(n322), .CK(clk), .RN(n801), .Q(read_count[2]) );
  DFFRX1 \pixel_buffer_reg[2][6]  ( .D(n276), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[2][6] ) );
  DFFRX1 \pixel_buffer_reg[1][6]  ( .D(n284), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[1][6] ) );
  DFFRX1 \pixel_buffer_reg[0][6]  ( .D(n292), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[0][6] ) );
  DFFRX1 \pixel_buffer_reg[3][6]  ( .D(n268), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[3][6] ) );
  DFFRX1 \row_reg[4]  ( .D(n328), .CK(clk), .RN(n801), .Q(N234), .QN(n457) );
  AND2X2 U289 ( .A(n422), .B(N165), .Y(n342) );
  AND2X2 U290 ( .A(n423), .B(n434), .Y(n343) );
  AND2X2 U291 ( .A(n423), .B(N302), .Y(n344) );
  AND2X2 U292 ( .A(N235), .B(n420), .Y(n345) );
  NOR3X1 U293 ( .A(read_count[1]), .B(read_count[2]), .C(read_count[0]), .Y(
        n579) );
  OAI211XL U294 ( .A0(state[2]), .A1(n469), .B0(n470), .C0(n468), .Y(
        next_state[0]) );
  NAND2XL U295 ( .A(state[2]), .B(n480), .Y(n465) );
  NOR3XL U296 ( .A(state[0]), .B(state[2]), .C(n756), .Y(n471) );
  XOR2XL U297 ( .A(N236), .B(n345), .Y(N258) );
  XOR3XL U298 ( .A(N236), .B(n423), .C(\add_107/carry [13]), .Y(N222) );
  MXI2XL U299 ( .A(n764), .B(n765), .S0(N236), .Y(n758) );
  NAND3XL U300 ( .A(read_count[1]), .B(read_count[0]), .C(n488), .Y(n490) );
  NAND3XL U301 ( .A(read_count[0]), .B(n606), .C(read_count[1]), .Y(n484) );
  NAND4BXL U302 ( .AN(n463), .B(N162), .C(N164), .D(N163), .Y(N417) );
  NOR3XL U303 ( .A(N163), .B(N164), .C(n461), .Y(N136) );
  NAND3XL U304 ( .A(N162), .B(N164), .C(N163), .Y(n763) );
  NOR4XL U305 ( .A(n762), .B(N164), .C(N163), .D(N162), .Y(n761) );
  INVX16 U322 ( .A(reset), .Y(n801) );
  INVX3 U323 ( .A(gray_data[0]), .Y(n588) );
  NOR2X2 U324 ( .A(n470), .B(n428), .Y(n602) );
  NOR2X2 U325 ( .A(n470), .B(n484), .Y(n715) );
  NOR2BX2 U326 ( .AN(n507), .B(n470), .Y(n582) );
  NOR2BX2 U327 ( .AN(n426), .B(n470), .Y(n591) );
  NOR2BX2 U328 ( .AN(n427), .B(n470), .Y(n596) );
  NOR2BX2 U329 ( .AN(n430), .B(n470), .Y(n694) );
  NAND2X2 U330 ( .A(\pixel_buffer[4][0] ), .B(n435), .Y(n631) );
  NAND3X2 U331 ( .A(n758), .B(n451), .C(n759), .Y(n757) );
  NOR2BX2 U332 ( .AN(N417), .B(n419), .Y(n481) );
  NOR2BX2 U333 ( .AN(n431), .B(n470), .Y(n736) );
  OR2X2 U334 ( .A(n435), .B(\pixel_buffer[4][0] ), .Y(n630) );
  NAND2X2 U335 ( .A(n432), .B(n607), .Y(n613) );
  BUFX12 U336 ( .A(n815), .Y(lbp_addr[0]) );
  BUFX12 U337 ( .A(n814), .Y(lbp_addr[1]) );
  BUFX12 U338 ( .A(n813), .Y(lbp_addr[2]) );
  BUFX12 U339 ( .A(n812), .Y(lbp_addr[3]) );
  BUFX12 U340 ( .A(n811), .Y(lbp_addr[4]) );
  BUFX12 U341 ( .A(n810), .Y(lbp_addr[5]) );
  BUFX12 U342 ( .A(n809), .Y(lbp_addr[6]) );
  BUFX12 U343 ( .A(n808), .Y(lbp_addr[7]) );
  BUFX12 U344 ( .A(n807), .Y(lbp_addr[8]) );
  BUFX12 U345 ( .A(n806), .Y(lbp_addr[9]) );
  BUFX12 U346 ( .A(n805), .Y(lbp_addr[10]) );
  BUFX12 U347 ( .A(n804), .Y(lbp_addr[11]) );
  BUFX12 U348 ( .A(n803), .Y(lbp_addr[12]) );
  BUFX12 U349 ( .A(n802), .Y(lbp_addr[13]) );
  BUFX12 U350 ( .A(n824), .Y(finish) );
  BUFX12 U351 ( .A(n823), .Y(lbp_data[0]) );
  BUFX12 U352 ( .A(n822), .Y(lbp_data[1]) );
  BUFX12 U353 ( .A(n821), .Y(lbp_data[2]) );
  BUFX12 U354 ( .A(n820), .Y(lbp_data[3]) );
  BUFX12 U355 ( .A(n816), .Y(lbp_data[7]) );
  BUFX12 U356 ( .A(n819), .Y(lbp_data[4]) );
  BUFX12 U357 ( .A(n818), .Y(lbp_data[5]) );
  BUFX12 U358 ( .A(n817), .Y(lbp_data[6]) );
  NOR2X2 U359 ( .A(n419), .B(N417), .Y(n479) );
  OAI21X1 U360 ( .A0(n454), .A1(n457), .B0(n455), .Y(N169) );
  NOR2BX2 U361 ( .AN(n429), .B(n470), .Y(n608) );
  MXI2XL U362 ( .A(n739), .B(n588), .S0(n736), .Y(n223) );
  MXI2XL U363 ( .A(n697), .B(n588), .S0(n694), .Y(n241) );
  MXI2XL U364 ( .A(n599), .B(n588), .S0(n596), .Y(n270) );
  MXI2XL U365 ( .A(n594), .B(n588), .S0(n591), .Y(n278) );
  MXI2XL U366 ( .A(n587), .B(n588), .S0(n582), .Y(n286) );
  MXI2XL U367 ( .A(n718), .B(n588), .S0(n715), .Y(n232) );
  MXI2XL U368 ( .A(n605), .B(n588), .S0(n602), .Y(n262) );
  MXI2XL U369 ( .A(n612), .B(n586), .S0(n608), .Y(n258) );
  MXI2XL U370 ( .A(n598), .B(n586), .S0(n596), .Y(n274) );
  MXI2XL U371 ( .A(n593), .B(n586), .S0(n591), .Y(n282) );
  MXI2XL U372 ( .A(n585), .B(n586), .S0(n582), .Y(n290) );
  MXI2XL U373 ( .A(n604), .B(n586), .S0(n602), .Y(n266) );
  MXI2XL U374 ( .A(n611), .B(n584), .S0(n608), .Y(n259) );
  MXI2XL U375 ( .A(n597), .B(n584), .S0(n596), .Y(n275) );
  MXI2XL U376 ( .A(n592), .B(n584), .S0(n591), .Y(n283) );
  MXI2XL U377 ( .A(n583), .B(n584), .S0(n582), .Y(n291) );
  MXI2XL U378 ( .A(n603), .B(n584), .S0(n602), .Y(n267) );
  MXI2XL U379 ( .A(n737), .B(n610), .S0(n736), .Y(n229) );
  MXI2XL U380 ( .A(n695), .B(n610), .S0(n694), .Y(n247) );
  MXI2XL U381 ( .A(n716), .B(n610), .S0(n715), .Y(n238) );
  MXI2XL U382 ( .A(n738), .B(n691), .S0(n736), .Y(n225) );
  MXI2XL U383 ( .A(n696), .B(n691), .S0(n694), .Y(n243) );
  MXI2XL U384 ( .A(n717), .B(n691), .S0(n715), .Y(n234) );
  MXI2XL U385 ( .A(n609), .B(n610), .S0(n608), .Y(n260) );
  MXI2XL U386 ( .A(n735), .B(n581), .S0(n736), .Y(n230) );
  MXI2XL U387 ( .A(n693), .B(n581), .S0(n694), .Y(n248) );
  MXI2XL U388 ( .A(n595), .B(n581), .S0(n596), .Y(n277) );
  MXI2XL U389 ( .A(n590), .B(n581), .S0(n591), .Y(n285) );
  MXI2XL U390 ( .A(n580), .B(n581), .S0(n582), .Y(n293) );
  MXI2XL U391 ( .A(n714), .B(n581), .S0(n715), .Y(n239) );
  MXI2XL U392 ( .A(n601), .B(n581), .S0(n602), .Y(n269) );
  MXI2XL U393 ( .A(n607), .B(n581), .S0(n608), .Y(n261) );
  MX2XL U394 ( .A(n437), .B(N303), .S0(n479), .Y(n331) );
  MX2XL U395 ( .A(n438), .B(N304), .S0(n479), .Y(n330) );
  MX2XL U396 ( .A(n439), .B(N305), .S0(n479), .Y(n329) );
  MX2XL U397 ( .A(n434), .B(N302), .S0(n479), .Y(n340) );
  AO22XL U398 ( .A0(n419), .A1(N164), .B0(N193), .B1(n481), .Y(n332) );
  AO22XL U399 ( .A0(n419), .A1(N163), .B0(N192), .B1(n481), .Y(n333) );
  AO22XL U400 ( .A0(n419), .A1(N162), .B0(N191), .B1(n481), .Y(n334) );
  MX2XL U401 ( .A(gray_addr[13]), .B(n574), .S0(n433), .Y(n294) );
  MX2XL U402 ( .A(gray_addr[12]), .B(n569), .S0(n433), .Y(n295) );
  OAI211XL U403 ( .A0(n435), .A1(n588), .B0(n692), .C0(n630), .Y(n690) );
  MX2XL U404 ( .A(gray_addr[11]), .B(n564), .S0(n433), .Y(n296) );
  MX2XL U405 ( .A(gray_addr[10]), .B(n559), .S0(n433), .Y(n297) );
  MX2XL U406 ( .A(gray_addr[9]), .B(n554), .S0(n433), .Y(n298) );
  MX2XL U407 ( .A(gray_addr[8]), .B(n549), .S0(n433), .Y(n299) );
  MX2XL U408 ( .A(gray_addr[6]), .B(n539), .S0(n433), .Y(n301) );
  MX2XL U409 ( .A(gray_addr[7]), .B(n544), .S0(n433), .Y(n300) );
  MX2XL U410 ( .A(\pixel_buffer[7][3] ), .B(gray_data[3]), .S0(n736), .Y(n226)
         );
  MX2XL U411 ( .A(\pixel_buffer[5][3] ), .B(gray_data[3]), .S0(n694), .Y(n244)
         );
  MX2XL U412 ( .A(\pixel_buffer[4][3] ), .B(gray_data[3]), .S0(n608), .Y(n257)
         );
  MX2XL U413 ( .A(\pixel_buffer[2][3] ), .B(gray_data[3]), .S0(n596), .Y(n273)
         );
  MX2XL U414 ( .A(\pixel_buffer[1][3] ), .B(gray_data[3]), .S0(n591), .Y(n281)
         );
  MX2XL U415 ( .A(\pixel_buffer[0][3] ), .B(gray_data[3]), .S0(n582), .Y(n289)
         );
  MX2XL U416 ( .A(\pixel_buffer[6][3] ), .B(gray_data[3]), .S0(n715), .Y(n235)
         );
  MX2XL U417 ( .A(\pixel_buffer[3][3] ), .B(gray_data[3]), .S0(n602), .Y(n265)
         );
  MX2XL U418 ( .A(\pixel_buffer[7][1] ), .B(gray_data[1]), .S0(n736), .Y(n224)
         );
  MX2XL U419 ( .A(\pixel_buffer[5][1] ), .B(gray_data[1]), .S0(n694), .Y(n242)
         );
  MX2XL U420 ( .A(n435), .B(gray_data[1]), .S0(n608), .Y(n255) );
  MX2XL U421 ( .A(\pixel_buffer[2][1] ), .B(gray_data[1]), .S0(n596), .Y(n271)
         );
  MX2XL U422 ( .A(\pixel_buffer[1][1] ), .B(gray_data[1]), .S0(n591), .Y(n279)
         );
  MX2XL U423 ( .A(\pixel_buffer[0][1] ), .B(gray_data[1]), .S0(n582), .Y(n287)
         );
  MX2XL U424 ( .A(\pixel_buffer[6][1] ), .B(gray_data[1]), .S0(n715), .Y(n233)
         );
  MX2XL U425 ( .A(\pixel_buffer[3][1] ), .B(gray_data[1]), .S0(n602), .Y(n263)
         );
  MX2XL U426 ( .A(\pixel_buffer[2][6] ), .B(gray_data[6]), .S0(n596), .Y(n276)
         );
  MX2XL U427 ( .A(\pixel_buffer[1][6] ), .B(gray_data[6]), .S0(n591), .Y(n284)
         );
  MX2XL U428 ( .A(\pixel_buffer[0][6] ), .B(gray_data[6]), .S0(n582), .Y(n292)
         );
  MX2XL U429 ( .A(\pixel_buffer[3][6] ), .B(gray_data[6]), .S0(n602), .Y(n268)
         );
  MX2XL U430 ( .A(n436), .B(gray_data[2]), .S0(n608), .Y(n256) );
  MX2XL U431 ( .A(\pixel_buffer[2][2] ), .B(gray_data[2]), .S0(n596), .Y(n272)
         );
  MX2XL U432 ( .A(\pixel_buffer[1][2] ), .B(gray_data[2]), .S0(n591), .Y(n280)
         );
  MX2XL U433 ( .A(\pixel_buffer[0][2] ), .B(gray_data[2]), .S0(n582), .Y(n288)
         );
  MX2XL U434 ( .A(\pixel_buffer[3][2] ), .B(gray_data[2]), .S0(n602), .Y(n264)
         );
  MX2XL U435 ( .A(\pixel_buffer[7][5] ), .B(gray_data[5]), .S0(n736), .Y(n228)
         );
  MX2XL U436 ( .A(\pixel_buffer[5][5] ), .B(gray_data[5]), .S0(n694), .Y(n246)
         );
  MX2XL U437 ( .A(\pixel_buffer[6][5] ), .B(gray_data[5]), .S0(n715), .Y(n237)
         );
  MX2XL U438 ( .A(\pixel_buffer[7][4] ), .B(gray_data[4]), .S0(n736), .Y(n227)
         );
  MX2XL U439 ( .A(\pixel_buffer[5][4] ), .B(gray_data[4]), .S0(n694), .Y(n245)
         );
  MX2XL U440 ( .A(\pixel_buffer[6][4] ), .B(gray_data[4]), .S0(n715), .Y(n236)
         );
  MX2XL U441 ( .A(\pixel_buffer[4][0] ), .B(gray_data[0]), .S0(n608), .Y(n254)
         );
  OAI211XL U442 ( .A0(n435), .A1(n739), .B0(n755), .C0(n630), .Y(n754) );
  OAI211XL U443 ( .A0(n435), .A1(n718), .B0(n734), .C0(n630), .Y(n733) );
  OAI211XL U444 ( .A0(n435), .A1(n697), .B0(n713), .C0(n630), .Y(n712) );
  OAI211XL U445 ( .A0(n435), .A1(n605), .B0(n676), .C0(n630), .Y(n675) );
  OAI211XL U446 ( .A0(n435), .A1(n599), .B0(n661), .C0(n630), .Y(n660) );
  OAI211XL U447 ( .A0(n435), .A1(n594), .B0(n646), .C0(n630), .Y(n645) );
  OAI211XL U448 ( .A0(n435), .A1(n587), .B0(n629), .C0(n630), .Y(n628) );
  MX2XL U449 ( .A(gray_addr[5]), .B(n534), .S0(n433), .Y(n302) );
  MX2XL U450 ( .A(gray_addr[4]), .B(n529), .S0(n433), .Y(n303) );
  MX2XL U451 ( .A(gray_addr[3]), .B(n524), .S0(n433), .Y(n304) );
  MX2XL U452 ( .A(N234), .B(N306), .S0(n479), .Y(n328) );
  MX2XL U453 ( .A(N235), .B(N307), .S0(n479), .Y(n327) );
  MX2XL U454 ( .A(N236), .B(N308), .S0(n479), .Y(n326) );
  MX2XL U455 ( .A(gray_addr[0]), .B(n500), .S0(n433), .Y(n307) );
  MX2XL U456 ( .A(gray_addr[1]), .B(n514), .S0(n433), .Y(n306) );
  MX2XL U457 ( .A(gray_addr[2]), .B(n519), .S0(n433), .Y(n305) );
  CLKBUFX3 U458 ( .A(N136), .Y(n422) );
  CLKBUFX3 U459 ( .A(n491), .Y(n433) );
  CLKBUFX3 U460 ( .A(n448), .Y(n446) );
  CLKBUFX3 U461 ( .A(n449), .Y(n445) );
  CLKBUFX3 U462 ( .A(n449), .Y(n444) );
  CLKBUFX3 U463 ( .A(n440), .Y(n443) );
  CLKBUFX3 U464 ( .A(n440), .Y(n442) );
  CLKBUFX3 U465 ( .A(n448), .Y(n441) );
  CLKBUFX3 U466 ( .A(n448), .Y(n447) );
  ADDFXL U467 ( .A(N169), .B(n422), .CI(\add_104/carry [11]), .CO(
        \add_104/carry [12]), .S(N148) );
  ADDFXL U468 ( .A(N166), .B(n422), .CI(n342), .CO(\add_104/carry [9]), .S(
        N145) );
  ADDFXL U469 ( .A(N167), .B(n422), .CI(\add_104/carry [9]), .CO(
        \add_104/carry [10]), .S(N146) );
  ADDFXL U470 ( .A(N168), .B(n422), .CI(\add_104/carry [10]), .CO(
        \add_104/carry [11]), .S(N147) );
  AND2X2 U471 ( .A(N169), .B(n405), .Y(n404) );
  ADDFXL U472 ( .A(N305), .B(n422), .CI(\add_110_2/carry [10]), .CO(
        \add_110_2/carry [11]), .S(N284) );
  ADDFXL U473 ( .A(N304), .B(n423), .CI(\add_110_2/carry [9]), .CO(
        \add_110_2/carry [10]), .S(N283) );
  ADDFXL U474 ( .A(N303), .B(n423), .CI(n344), .CO(\add_110_2/carry [9]), .S(
        N282) );
  AND2X2 U475 ( .A(N168), .B(n406), .Y(n405) );
  AND2X2 U476 ( .A(N167), .B(n407), .Y(n406) );
  AND2X2 U477 ( .A(N166), .B(n412), .Y(n407) );
  INVX3 U478 ( .A(n419), .Y(n451) );
  AND2X2 U479 ( .A(N303), .B(n413), .Y(n408) );
  AND2X2 U480 ( .A(N304), .B(n408), .Y(n409) );
  AND2X2 U481 ( .A(N305), .B(n409), .Y(n410) );
  XOR2X1 U482 ( .A(N305), .B(n409), .Y(N334) );
  XOR2X1 U483 ( .A(N304), .B(n408), .Y(N333) );
  INVX3 U484 ( .A(n419), .Y(n450) );
  XOR2X1 U485 ( .A(N303), .B(n413), .Y(N332) );
  CLKBUFX3 U486 ( .A(n449), .Y(n448) );
  CLKINVX1 U487 ( .A(n434), .Y(N165) );
  ADDFXL U488 ( .A(N170), .B(n422), .CI(\add_104/carry [12]), .CO(
        \add_104/carry [13]), .S(N149) );
  XOR2X1 U489 ( .A(N170), .B(n404), .Y(N199) );
  XOR2XL U490 ( .A(N169), .B(n405), .Y(N198) );
  AND2X2 U491 ( .A(N170), .B(n404), .Y(n411) );
  CLKBUFX3 U492 ( .A(N136), .Y(n423) );
  ADDFXL U493 ( .A(N306), .B(n422), .CI(\add_110_2/carry [11]), .CO(
        \add_110_2/carry [12]), .S(N285) );
  ADDFXL U494 ( .A(N307), .B(n422), .CI(\add_110_2/carry [12]), .CO(
        \add_110_2/carry [13]), .S(N286) );
  ADDFXL U495 ( .A(n437), .B(n423), .CI(n343), .CO(\add_107/carry [9]), .S(
        N217) );
  ADDFXL U496 ( .A(n438), .B(n423), .CI(\add_107/carry [9]), .CO(
        \add_107/carry [10]), .S(N218) );
  ADDFXL U497 ( .A(n439), .B(n423), .CI(\add_107/carry [10]), .CO(
        \add_107/carry [11]), .S(N219) );
  XOR2X1 U498 ( .A(N168), .B(n406), .Y(N197) );
  XOR2X1 U499 ( .A(N167), .B(n407), .Y(N196) );
  XOR2X1 U500 ( .A(n439), .B(n417), .Y(N255) );
  XOR2X1 U501 ( .A(N166), .B(n412), .Y(N195) );
  XOR2X1 U502 ( .A(n438), .B(n416), .Y(N254) );
  XOR2X1 U503 ( .A(N186), .B(N165), .Y(N194) );
  XOR2X1 U504 ( .A(n422), .B(N165), .Y(N144) );
  CLKBUFX3 U505 ( .A(n510), .Y(n429) );
  AND2X2 U506 ( .A(n489), .B(n606), .Y(n510) );
  CLKAND2X3 U507 ( .A(n589), .B(n489), .Y(n507) );
  NAND2X2 U508 ( .A(n433), .B(n466), .Y(n470) );
  XOR2X1 U509 ( .A(n437), .B(n415), .Y(N253) );
  AND2X2 U510 ( .A(N186), .B(N165), .Y(n412) );
  CLKBUFX3 U511 ( .A(n513), .Y(n431) );
  NOR2BX1 U512 ( .AN(n579), .B(n483), .Y(n513) );
  CLKBUFX3 U513 ( .A(n509), .Y(n428) );
  NAND3X1 U514 ( .A(n600), .B(n487), .C(n606), .Y(n509) );
  XOR2X1 U515 ( .A(N186), .B(n434), .Y(N252) );
  XOR2X1 U516 ( .A(n423), .B(N302), .Y(N281) );
  XOR2X1 U517 ( .A(n423), .B(n434), .Y(N216) );
  CLKBUFX3 U518 ( .A(n508), .Y(n427) );
  NOR3BXL U519 ( .AN(n589), .B(n487), .C(n600), .Y(n508) );
  XNOR2X1 U520 ( .A(N308), .B(n421), .Y(N337) );
  NAND2X1 U521 ( .A(N307), .B(n414), .Y(n421) );
  AND2X2 U522 ( .A(N186), .B(N302), .Y(n413) );
  AND2X2 U523 ( .A(N306), .B(n410), .Y(n414) );
  AND2X2 U524 ( .A(N186), .B(n434), .Y(n415) );
  AND2X2 U525 ( .A(n437), .B(n415), .Y(n416) );
  AND2X2 U526 ( .A(n438), .B(n416), .Y(n417) );
  AND2X2 U527 ( .A(n439), .B(n417), .Y(n418) );
  XOR2X1 U528 ( .A(N307), .B(n414), .Y(N336) );
  XOR2X1 U529 ( .A(N306), .B(n410), .Y(N335) );
  CLKBUFX3 U530 ( .A(n512), .Y(n425) );
  CLKINVX1 U531 ( .A(n484), .Y(n512) );
  XOR2X1 U532 ( .A(N186), .B(N302), .Y(N331) );
  CLKBUFX3 U533 ( .A(n440), .Y(n449) );
  INVX3 U534 ( .A(gray_data[7]), .Y(n581) );
  XOR2X1 U535 ( .A(N171), .B(n411), .Y(N200) );
  XOR3X1 U536 ( .A(N171), .B(n422), .C(\add_104/carry [13]), .Y(N150) );
  CLKBUFX3 U537 ( .A(N230), .Y(n434) );
  CLKBUFX3 U538 ( .A(N231), .Y(n437) );
  CLKBUFX3 U539 ( .A(N232), .Y(n438) );
  XOR3X1 U540 ( .A(N308), .B(n422), .C(\add_110_2/carry [13]), .Y(N287) );
  ADDFXL U541 ( .A(N234), .B(n423), .CI(\add_107/carry [11]), .CO(
        \add_107/carry [12]), .S(N220) );
  ADDFXL U542 ( .A(N235), .B(n423), .CI(\add_107/carry [12]), .CO(
        \add_107/carry [13]), .S(N221) );
  XOR2X1 U543 ( .A(N235), .B(n420), .Y(N257) );
  CLKBUFX3 U544 ( .A(N233), .Y(n439) );
  XOR2X1 U545 ( .A(N234), .B(n418), .Y(N256) );
  OR3X2 U546 ( .A(n472), .B(state[2]), .C(n756), .Y(n419) );
  CLKBUFX3 U547 ( .A(n511), .Y(n430) );
  NOR3BXL U548 ( .AN(n606), .B(read_count[0]), .C(n487), .Y(n511) );
  CLKBUFX3 U549 ( .A(\pixel_buffer[4][1] ), .Y(n435) );
  CLKBUFX3 U550 ( .A(n505), .Y(n426) );
  NOR3BXL U551 ( .AN(n589), .B(n487), .C(read_count[0]), .Y(n505) );
  AND2X2 U552 ( .A(N234), .B(n418), .Y(n420) );
  NOR3X1 U553 ( .A(state[1]), .B(state[2]), .C(n472), .Y(n491) );
  CLKBUFX3 U554 ( .A(n506), .Y(n424) );
  NOR2BX1 U555 ( .AN(n579), .B(read_count[3]), .Y(n506) );
  CLKBUFX3 U556 ( .A(n471), .Y(n432) );
  CLKBUFX3 U557 ( .A(\pixel_buffer[4][2] ), .Y(n436) );
  CLKBUFX3 U558 ( .A(n801), .Y(n440) );
  NAND2BX1 U559 ( .AN(n437), .B(N165), .Y(n452) );
  OAI2BB1X1 U560 ( .A0N(n434), .A1N(n437), .B0(n452), .Y(N166) );
  OR2X1 U561 ( .A(n452), .B(n438), .Y(n453) );
  OAI2BB1X1 U562 ( .A0N(n452), .A1N(n438), .B0(n453), .Y(N167) );
  NOR2X1 U563 ( .A(n453), .B(n439), .Y(n454) );
  AO21X1 U564 ( .A0(n453), .A1(n439), .B0(n454), .Y(N168) );
  NAND2X1 U565 ( .A(n454), .B(n457), .Y(n455) );
  XNOR2X1 U566 ( .A(N235), .B(n455), .Y(N170) );
  NOR2X1 U567 ( .A(N235), .B(n455), .Y(n456) );
  XOR2X1 U568 ( .A(N236), .B(n456), .Y(N171) );
  NAND2BX1 U569 ( .AN(N159), .B(n492), .Y(n458) );
  OAI2BB1X1 U570 ( .A0N(N158), .A1N(N159), .B0(n458), .Y(N138) );
  OR2X1 U571 ( .A(n458), .B(N160), .Y(n459) );
  OAI2BB1X1 U572 ( .A0N(n458), .A1N(N160), .B0(n459), .Y(N139) );
  OR2X1 U573 ( .A(n459), .B(N161), .Y(n460) );
  OAI2BB1X1 U574 ( .A0N(n459), .A1N(N161), .B0(n460), .Y(N140) );
  OR2X1 U575 ( .A(n460), .B(N162), .Y(n461) );
  OAI2BB1X1 U576 ( .A0N(n460), .A1N(N162), .B0(n461), .Y(N141) );
  XNOR2X1 U577 ( .A(N163), .B(n461), .Y(N142) );
  OAI21XL U578 ( .A0(N163), .A1(n461), .B0(N164), .Y(n462) );
  NAND2BX1 U579 ( .AN(n423), .B(n462), .Y(N143) );
  NAND4X1 U580 ( .A(N161), .B(N160), .C(N159), .D(N158), .Y(n463) );
  OAI21XL U581 ( .A0(n464), .A1(n419), .B0(n465), .Y(next_state[2]) );
  OAI21XL U582 ( .A0(n466), .A1(n467), .B0(n468), .Y(next_state[1]) );
  CLKINVX1 U583 ( .A(n432), .Y(n468) );
  AOI22X1 U584 ( .A0(n464), .A1(state[1]), .B0(gray_ready), .B1(n472), .Y(n469) );
  NAND4X1 U585 ( .A(n473), .B(n474), .C(n475), .D(n476), .Y(n464) );
  NOR4X1 U586 ( .A(n434), .B(n498), .C(n496), .D(n497), .Y(n476) );
  NOR3X1 U587 ( .A(n495), .B(n494), .C(n493), .Y(n475) );
  AND4X1 U588 ( .A(n492), .B(n437), .C(n438), .D(n439), .Y(n474) );
  NOR3BXL U589 ( .AN(N236), .B(n477), .C(n478), .Y(n473) );
  OAI31XL U590 ( .A0(n480), .A1(state[2]), .A2(n784), .B0(n465), .Y(n339) );
  OAI2BB2XL U591 ( .B0(n450), .B1(n492), .A0N(N187), .A1N(n481), .Y(n338) );
  OAI2BB2XL U592 ( .B0(n450), .B1(n493), .A0N(N188), .A1N(n481), .Y(n337) );
  OAI2BB2XL U593 ( .B0(n451), .B1(n494), .A0N(N189), .A1N(n481), .Y(n336) );
  OAI2BB2XL U594 ( .B0(n451), .B1(n495), .A0N(N190), .A1N(n481), .Y(n335) );
  OAI22XL U595 ( .A0(n482), .A1(n483), .B0(n484), .B1(n485), .Y(n325) );
  OAI2BB2XL U597 ( .B0(n486), .B1(n487), .A0N(n488), .A1N(n489), .Y(n323) );
  MXI2X1 U598 ( .A(n490), .B(n482), .S0(read_count[2]), .Y(n322) );
  OA21XL U599 ( .A0(read_count[1]), .A1(n467), .B0(n486), .Y(n482) );
  OA21XL U600 ( .A0(read_count[0]), .A1(n467), .B0(N443), .Y(n486) );
  CLKINVX1 U601 ( .A(n433), .Y(n467) );
  CLKINVX1 U602 ( .A(n485), .Y(n488) );
  NAND2X1 U603 ( .A(n433), .B(N443), .Y(n485) );
  MXI2X1 U604 ( .A(n783), .B(n492), .S0(n450), .Y(n321) );
  MXI2X1 U605 ( .A(n782), .B(n493), .S0(n450), .Y(n320) );
  MXI2X1 U606 ( .A(n781), .B(n494), .S0(n450), .Y(n319) );
  MXI2X1 U607 ( .A(n780), .B(n495), .S0(n450), .Y(n318) );
  MXI2X1 U608 ( .A(n779), .B(n496), .S0(n450), .Y(n317) );
  MXI2X1 U609 ( .A(n778), .B(n497), .S0(n450), .Y(n316) );
  MXI2X1 U610 ( .A(n777), .B(n498), .S0(n450), .Y(n315) );
  MXI2X1 U611 ( .A(n776), .B(n349), .S0(n450), .Y(n314) );
  MXI2X1 U612 ( .A(n775), .B(n347), .S0(n450), .Y(n313) );
  MXI2X1 U613 ( .A(n774), .B(n346), .S0(n450), .Y(n312) );
  MXI2X1 U614 ( .A(n773), .B(n348), .S0(n450), .Y(n311) );
  MXI2X1 U615 ( .A(n772), .B(n477), .S0(n451), .Y(n310) );
  MXI2X1 U616 ( .A(n771), .B(n478), .S0(n450), .Y(n309) );
  MXI2X1 U617 ( .A(n770), .B(n499), .S0(n451), .Y(n308) );
  NAND4X1 U618 ( .A(n501), .B(n502), .C(n503), .D(n504), .Y(n500) );
  AOI222XL U619 ( .A0(N187), .A1(n426), .B0(n492), .B1(n424), .C0(N158), .C1(
        n507), .Y(n504) );
  AOI2BB2X1 U620 ( .B0(n492), .B1(n427), .A0N(n492), .A1N(n428), .Y(n503) );
  AOI22X1 U621 ( .A0(N187), .A1(n429), .B0(n492), .B1(n430), .Y(n502) );
  AOI22X1 U622 ( .A0(N158), .A1(n425), .B0(N187), .B1(n431), .Y(n501) );
  NAND4X1 U623 ( .A(n515), .B(n516), .C(n517), .D(n518), .Y(n514) );
  AOI222XL U624 ( .A0(N188), .A1(n426), .B0(N138), .B1(n424), .C0(N159), .C1(
        n507), .Y(n518) );
  AOI2BB2X1 U625 ( .B0(N138), .B1(n427), .A0N(n493), .A1N(n428), .Y(n517) );
  AOI22X1 U626 ( .A0(N188), .A1(n429), .B0(N138), .B1(n430), .Y(n516) );
  AOI22X1 U627 ( .A0(N159), .A1(n425), .B0(N188), .B1(n431), .Y(n515) );
  NAND4X1 U628 ( .A(n520), .B(n521), .C(n522), .D(n523), .Y(n519) );
  AOI222XL U629 ( .A0(N189), .A1(n426), .B0(N139), .B1(n424), .C0(N160), .C1(
        n507), .Y(n523) );
  AOI2BB2X1 U630 ( .B0(N139), .B1(n427), .A0N(n494), .A1N(n428), .Y(n522) );
  AOI22X1 U631 ( .A0(N189), .A1(n429), .B0(N139), .B1(n430), .Y(n521) );
  AOI22X1 U632 ( .A0(N160), .A1(n425), .B0(N189), .B1(n431), .Y(n520) );
  NAND4X1 U633 ( .A(n525), .B(n526), .C(n527), .D(n528), .Y(n524) );
  AOI222XL U634 ( .A0(N190), .A1(n426), .B0(N140), .B1(n424), .C0(N161), .C1(
        n507), .Y(n528) );
  AOI2BB2X1 U635 ( .B0(N140), .B1(n427), .A0N(n495), .A1N(n428), .Y(n527) );
  AOI22X1 U636 ( .A0(N190), .A1(n429), .B0(N140), .B1(n430), .Y(n526) );
  AOI22X1 U637 ( .A0(N161), .A1(n425), .B0(N190), .B1(n431), .Y(n525) );
  NAND4X1 U638 ( .A(n530), .B(n531), .C(n532), .D(n533), .Y(n529) );
  AOI222XL U639 ( .A0(N191), .A1(n426), .B0(N141), .B1(n424), .C0(N162), .C1(
        n507), .Y(n533) );
  AOI2BB2X1 U640 ( .B0(N141), .B1(n427), .A0N(n496), .A1N(n428), .Y(n532) );
  AOI22X1 U641 ( .A0(N191), .A1(n429), .B0(N141), .B1(n430), .Y(n531) );
  AOI22X1 U642 ( .A0(N162), .A1(n425), .B0(N191), .B1(n431), .Y(n530) );
  NAND4X1 U643 ( .A(n535), .B(n536), .C(n537), .D(n538), .Y(n534) );
  AOI222XL U644 ( .A0(N192), .A1(n426), .B0(N142), .B1(n424), .C0(N163), .C1(
        n507), .Y(n538) );
  AOI2BB2X1 U645 ( .B0(N142), .B1(n427), .A0N(n497), .A1N(n428), .Y(n537) );
  AOI22X1 U646 ( .A0(N192), .A1(n429), .B0(N142), .B1(n430), .Y(n536) );
  AOI22X1 U647 ( .A0(N163), .A1(n425), .B0(N192), .B1(n431), .Y(n535) );
  NAND4X1 U648 ( .A(n540), .B(n541), .C(n542), .D(n543), .Y(n539) );
  AOI222XL U649 ( .A0(N193), .A1(n426), .B0(N143), .B1(n424), .C0(N164), .C1(
        n507), .Y(n543) );
  AOI2BB2X1 U650 ( .B0(N143), .B1(n427), .A0N(n498), .A1N(n428), .Y(n542) );
  AOI22X1 U651 ( .A0(N193), .A1(n429), .B0(N143), .B1(n430), .Y(n541) );
  AOI22X1 U652 ( .A0(N164), .A1(n425), .B0(N193), .B1(n431), .Y(n540) );
  NAND4X1 U653 ( .A(n545), .B(n546), .C(n547), .D(n548), .Y(n544) );
  AOI222XL U654 ( .A0(N194), .A1(n426), .B0(N144), .B1(n424), .C0(N165), .C1(
        n507), .Y(n548) );
  AOI2BB2X1 U655 ( .B0(N216), .B1(n427), .A0N(n349), .A1N(n428), .Y(n547) );
  AOI22X1 U656 ( .A0(N252), .A1(n429), .B0(N281), .B1(n430), .Y(n546) );
  AOI22X1 U657 ( .A0(N302), .A1(n425), .B0(N331), .B1(n431), .Y(n545) );
  NAND4X1 U658 ( .A(n550), .B(n551), .C(n552), .D(n553), .Y(n549) );
  AOI222XL U659 ( .A0(N195), .A1(n426), .B0(N145), .B1(n424), .C0(N166), .C1(
        n507), .Y(n553) );
  AOI2BB2X1 U660 ( .B0(N217), .B1(n427), .A0N(n347), .A1N(n428), .Y(n552) );
  AOI22X1 U661 ( .A0(N253), .A1(n429), .B0(N282), .B1(n430), .Y(n551) );
  AOI22X1 U662 ( .A0(N303), .A1(n425), .B0(N332), .B1(n431), .Y(n550) );
  NAND4X1 U663 ( .A(n555), .B(n556), .C(n557), .D(n558), .Y(n554) );
  AOI222XL U664 ( .A0(N196), .A1(n426), .B0(N146), .B1(n424), .C0(N167), .C1(
        n507), .Y(n558) );
  AOI2BB2X1 U665 ( .B0(N218), .B1(n427), .A0N(n346), .A1N(n428), .Y(n557) );
  AOI22X1 U666 ( .A0(N254), .A1(n429), .B0(N283), .B1(n430), .Y(n556) );
  AOI22X1 U667 ( .A0(N304), .A1(n425), .B0(N333), .B1(n431), .Y(n555) );
  NAND4X1 U668 ( .A(n560), .B(n561), .C(n562), .D(n563), .Y(n559) );
  AOI222XL U669 ( .A0(N197), .A1(n426), .B0(N147), .B1(n424), .C0(N168), .C1(
        n507), .Y(n563) );
  AOI2BB2X1 U670 ( .B0(N219), .B1(n427), .A0N(n348), .A1N(n428), .Y(n562) );
  AOI22X1 U671 ( .A0(N255), .A1(n429), .B0(N284), .B1(n430), .Y(n561) );
  AOI22X1 U672 ( .A0(N305), .A1(n425), .B0(N334), .B1(n431), .Y(n560) );
  NAND4X1 U673 ( .A(n565), .B(n566), .C(n567), .D(n568), .Y(n564) );
  AOI222XL U674 ( .A0(N198), .A1(n426), .B0(N148), .B1(n424), .C0(N169), .C1(
        n507), .Y(n568) );
  AOI2BB2X1 U675 ( .B0(N220), .B1(n427), .A0N(n477), .A1N(n428), .Y(n567) );
  AOI22X1 U676 ( .A0(N256), .A1(n429), .B0(N285), .B1(n430), .Y(n566) );
  AOI22X1 U677 ( .A0(N306), .A1(n425), .B0(N335), .B1(n431), .Y(n565) );
  NAND4X1 U678 ( .A(n570), .B(n571), .C(n572), .D(n573), .Y(n569) );
  AOI222XL U679 ( .A0(N199), .A1(n426), .B0(N149), .B1(n424), .C0(N170), .C1(
        n507), .Y(n573) );
  AOI2BB2X1 U680 ( .B0(N221), .B1(n427), .A0N(n478), .A1N(n428), .Y(n572) );
  AOI22X1 U681 ( .A0(N257), .A1(n429), .B0(N286), .B1(n430), .Y(n571) );
  AOI22X1 U682 ( .A0(N307), .A1(n425), .B0(N336), .B1(n431), .Y(n570) );
  NAND4X1 U683 ( .A(n575), .B(n576), .C(n577), .D(n578), .Y(n574) );
  AOI222XL U684 ( .A0(N200), .A1(n426), .B0(N150), .B1(n424), .C0(N171), .C1(
        n507), .Y(n578) );
  AOI2BB2X1 U685 ( .B0(N222), .B1(n427), .A0N(n499), .A1N(n428), .Y(n577) );
  AOI22X1 U686 ( .A0(N258), .A1(n429), .B0(N287), .B1(n430), .Y(n576) );
  AOI22X1 U687 ( .A0(N308), .A1(n425), .B0(N337), .B1(n431), .Y(n575) );
  NOR2X1 U688 ( .A(read_count[2]), .B(read_count[3]), .Y(n589) );
  NOR2X1 U689 ( .A(n600), .B(read_count[1]), .Y(n489) );
  OAI21XL U690 ( .A0(n580), .A1(n613), .B0(n614), .Y(n253) );
  MXI2X1 U691 ( .A(n615), .B(n616), .S0(n432), .Y(n614) );
  AOI2BB2X1 U692 ( .B0(\pixel_buffer[4][7] ), .B1(n580), .A0N(n617), .A1N(n618), .Y(n616) );
  AOI2BB2X1 U693 ( .B0(\pixel_buffer[4][6] ), .B1(n619), .A0N(n620), .A1N(
        \pixel_buffer[0][6] ), .Y(n618) );
  NAND2X1 U694 ( .A(\pixel_buffer[0][6] ), .B(n620), .Y(n619) );
  OAI32X1 U695 ( .A0(n585), .A1(\pixel_buffer[4][4] ), .A2(n621), .B0(
        \pixel_buffer[4][5] ), .B1(n583), .Y(n620) );
  AOI211X1 U696 ( .A0(n622), .A1(n623), .B0(n624), .C0(n621), .Y(n617) );
  NOR2X1 U697 ( .A(n611), .B(\pixel_buffer[0][5] ), .Y(n621) );
  OAI22XL U698 ( .A0(\pixel_buffer[0][6] ), .A1(n609), .B0(
        \pixel_buffer[0][4] ), .B1(n612), .Y(n624) );
  OAI22XL U699 ( .A0(n625), .A1(n626), .B0(\pixel_buffer[0][3] ), .B1(n627), 
        .Y(n623) );
  AND2X1 U700 ( .A(n628), .B(\pixel_buffer[0][2] ), .Y(n626) );
  AOI2BB1X1 U701 ( .A0N(n628), .A1N(\pixel_buffer[0][2] ), .B0(n436), .Y(n625)
         );
  OAI21XL U702 ( .A0(\pixel_buffer[0][0] ), .A1(n631), .B0(
        \pixel_buffer[0][1] ), .Y(n629) );
  NAND2X1 U703 ( .A(\pixel_buffer[0][3] ), .B(n627), .Y(n622) );
  OAI21XL U704 ( .A0(n590), .A1(n613), .B0(n632), .Y(n252) );
  MXI2X1 U705 ( .A(n633), .B(n634), .S0(n432), .Y(n632) );
  AOI2BB2X1 U706 ( .B0(\pixel_buffer[4][7] ), .B1(n590), .A0N(n635), .A1N(n636), .Y(n634) );
  AOI2BB2X1 U707 ( .B0(\pixel_buffer[4][6] ), .B1(n637), .A0N(n638), .A1N(
        \pixel_buffer[1][6] ), .Y(n636) );
  NAND2X1 U708 ( .A(\pixel_buffer[1][6] ), .B(n638), .Y(n637) );
  OAI32X1 U709 ( .A0(n593), .A1(\pixel_buffer[4][4] ), .A2(n639), .B0(
        \pixel_buffer[4][5] ), .B1(n592), .Y(n638) );
  AOI211X1 U710 ( .A0(n640), .A1(n641), .B0(n642), .C0(n639), .Y(n635) );
  NOR2X1 U711 ( .A(n611), .B(\pixel_buffer[1][5] ), .Y(n639) );
  OAI22XL U712 ( .A0(\pixel_buffer[1][6] ), .A1(n609), .B0(
        \pixel_buffer[1][4] ), .B1(n612), .Y(n642) );
  OAI22XL U713 ( .A0(n643), .A1(n644), .B0(\pixel_buffer[1][3] ), .B1(n627), 
        .Y(n641) );
  AND2X1 U714 ( .A(n645), .B(\pixel_buffer[1][2] ), .Y(n644) );
  AOI2BB1X1 U715 ( .A0N(n645), .A1N(\pixel_buffer[1][2] ), .B0(n436), .Y(n643)
         );
  OAI21XL U716 ( .A0(\pixel_buffer[1][0] ), .A1(n631), .B0(
        \pixel_buffer[1][1] ), .Y(n646) );
  NAND2X1 U717 ( .A(\pixel_buffer[1][3] ), .B(n627), .Y(n640) );
  OAI21XL U718 ( .A0(n595), .A1(n613), .B0(n647), .Y(n251) );
  MXI2X1 U719 ( .A(n648), .B(n649), .S0(n432), .Y(n647) );
  AOI2BB2X1 U720 ( .B0(\pixel_buffer[4][7] ), .B1(n595), .A0N(n650), .A1N(n651), .Y(n649) );
  AOI2BB2X1 U721 ( .B0(\pixel_buffer[4][6] ), .B1(n652), .A0N(n653), .A1N(
        \pixel_buffer[2][6] ), .Y(n651) );
  NAND2X1 U722 ( .A(\pixel_buffer[2][6] ), .B(n653), .Y(n652) );
  OAI32X1 U723 ( .A0(n598), .A1(\pixel_buffer[4][4] ), .A2(n654), .B0(
        \pixel_buffer[4][5] ), .B1(n597), .Y(n653) );
  AOI211X1 U724 ( .A0(n655), .A1(n656), .B0(n657), .C0(n654), .Y(n650) );
  NOR2X1 U725 ( .A(n611), .B(\pixel_buffer[2][5] ), .Y(n654) );
  OAI22XL U726 ( .A0(\pixel_buffer[2][6] ), .A1(n609), .B0(
        \pixel_buffer[2][4] ), .B1(n612), .Y(n657) );
  OAI22XL U727 ( .A0(n658), .A1(n659), .B0(\pixel_buffer[2][3] ), .B1(n627), 
        .Y(n656) );
  AND2X1 U728 ( .A(n660), .B(\pixel_buffer[2][2] ), .Y(n659) );
  AOI2BB1X1 U729 ( .A0N(n660), .A1N(\pixel_buffer[2][2] ), .B0(n436), .Y(n658)
         );
  OAI21XL U730 ( .A0(\pixel_buffer[2][0] ), .A1(n631), .B0(
        \pixel_buffer[2][1] ), .Y(n661) );
  NAND2X1 U731 ( .A(\pixel_buffer[2][3] ), .B(n627), .Y(n655) );
  OAI21XL U732 ( .A0(n601), .A1(n613), .B0(n662), .Y(n250) );
  MXI2X1 U733 ( .A(n663), .B(n664), .S0(n432), .Y(n662) );
  AOI2BB2X1 U734 ( .B0(\pixel_buffer[4][7] ), .B1(n601), .A0N(n665), .A1N(n666), .Y(n664) );
  AOI2BB2X1 U735 ( .B0(\pixel_buffer[4][6] ), .B1(n667), .A0N(n668), .A1N(
        \pixel_buffer[3][6] ), .Y(n666) );
  NAND2X1 U736 ( .A(\pixel_buffer[3][6] ), .B(n668), .Y(n667) );
  OAI32X1 U737 ( .A0(n604), .A1(\pixel_buffer[4][4] ), .A2(n669), .B0(
        \pixel_buffer[4][5] ), .B1(n603), .Y(n668) );
  AOI211X1 U738 ( .A0(n670), .A1(n671), .B0(n672), .C0(n669), .Y(n665) );
  NOR2X1 U739 ( .A(n611), .B(\pixel_buffer[3][5] ), .Y(n669) );
  OAI22XL U740 ( .A0(\pixel_buffer[3][6] ), .A1(n609), .B0(
        \pixel_buffer[3][4] ), .B1(n612), .Y(n672) );
  OAI22XL U741 ( .A0(n673), .A1(n674), .B0(\pixel_buffer[3][3] ), .B1(n627), 
        .Y(n671) );
  AND2X1 U742 ( .A(n675), .B(\pixel_buffer[3][2] ), .Y(n674) );
  AOI2BB1X1 U743 ( .A0N(n675), .A1N(\pixel_buffer[3][2] ), .B0(n436), .Y(n673)
         );
  OAI21XL U744 ( .A0(\pixel_buffer[3][0] ), .A1(n631), .B0(
        \pixel_buffer[3][1] ), .Y(n676) );
  NAND2X1 U745 ( .A(\pixel_buffer[3][3] ), .B(n627), .Y(n670) );
  OAI21XL U746 ( .A0(n581), .A1(n613), .B0(n677), .Y(n249) );
  MXI2X1 U747 ( .A(n678), .B(n679), .S0(n432), .Y(n677) );
  AOI2BB2X1 U748 ( .B0(\pixel_buffer[4][7] ), .B1(n581), .A0N(n680), .A1N(n681), .Y(n679) );
  AOI2BB2X1 U749 ( .B0(\pixel_buffer[4][6] ), .B1(n682), .A0N(n683), .A1N(
        gray_data[6]), .Y(n681) );
  NAND2X1 U750 ( .A(gray_data[6]), .B(n683), .Y(n682) );
  OAI32X1 U751 ( .A0(n586), .A1(\pixel_buffer[4][4] ), .A2(n684), .B0(
        \pixel_buffer[4][5] ), .B1(n584), .Y(n683) );
  CLKINVX1 U752 ( .A(gray_data[5]), .Y(n584) );
  CLKINVX1 U753 ( .A(gray_data[4]), .Y(n586) );
  AOI211X1 U754 ( .A0(n685), .A1(n686), .B0(n687), .C0(n684), .Y(n680) );
  NOR2X1 U755 ( .A(n611), .B(gray_data[5]), .Y(n684) );
  OAI22XL U756 ( .A0(gray_data[6]), .A1(n609), .B0(gray_data[4]), .B1(n612), 
        .Y(n687) );
  OAI22XL U757 ( .A0(n688), .A1(n689), .B0(gray_data[3]), .B1(n627), .Y(n686)
         );
  NOR2BX1 U758 ( .AN(n690), .B(n691), .Y(n689) );
  AOI2BB1X1 U759 ( .A0N(n690), .A1N(gray_data[2]), .B0(n436), .Y(n688) );
  OAI21XL U760 ( .A0(gray_data[0]), .A1(n631), .B0(gray_data[1]), .Y(n692) );
  NAND2X1 U761 ( .A(gray_data[3]), .B(n627), .Y(n685) );
  OAI21XL U762 ( .A0(n613), .A1(n693), .B0(n698), .Y(n240) );
  MXI2X1 U763 ( .A(n699), .B(n700), .S0(n432), .Y(n698) );
  AOI2BB2X1 U764 ( .B0(\pixel_buffer[4][7] ), .B1(n693), .A0N(n701), .A1N(n702), .Y(n700) );
  ACHCONX2 U765 ( .A(\pixel_buffer[4][6] ), .B(n703), .CI(n695), .CON(n702) );
  AOI32X1 U766 ( .A0(n704), .A1(n612), .A2(\pixel_buffer[5][4] ), .B0(
        \pixel_buffer[5][5] ), .B1(n611), .Y(n703) );
  CLKINVX1 U767 ( .A(n705), .Y(n704) );
  AOI211X1 U768 ( .A0(n706), .A1(n707), .B0(n708), .C0(n705), .Y(n701) );
  NOR2X1 U769 ( .A(n611), .B(\pixel_buffer[5][5] ), .Y(n705) );
  OAI22XL U770 ( .A0(\pixel_buffer[5][6] ), .A1(n609), .B0(
        \pixel_buffer[5][4] ), .B1(n612), .Y(n708) );
  OAI22XL U771 ( .A0(n709), .A1(n710), .B0(\pixel_buffer[5][3] ), .B1(n627), 
        .Y(n707) );
  NOR2X1 U772 ( .A(n436), .B(n711), .Y(n710) );
  AOI21X1 U773 ( .A0(n711), .A1(n436), .B0(n696), .Y(n709) );
  CLKINVX1 U774 ( .A(n712), .Y(n711) );
  OAI21XL U775 ( .A0(\pixel_buffer[5][0] ), .A1(n631), .B0(
        \pixel_buffer[5][1] ), .Y(n713) );
  NAND2X1 U776 ( .A(\pixel_buffer[5][3] ), .B(n627), .Y(n706) );
  NOR2BX1 U777 ( .AN(read_count[2]), .B(read_count[3]), .Y(n606) );
  OAI21XL U778 ( .A0(n613), .A1(n714), .B0(n719), .Y(n231) );
  MXI2X1 U779 ( .A(n720), .B(n721), .S0(n432), .Y(n719) );
  AOI2BB2X1 U780 ( .B0(\pixel_buffer[4][7] ), .B1(n714), .A0N(n722), .A1N(n723), .Y(n721) );
  ACHCONX2 U781 ( .A(\pixel_buffer[4][6] ), .B(n724), .CI(n716), .CON(n723) );
  AOI32X1 U782 ( .A0(n725), .A1(n612), .A2(\pixel_buffer[6][4] ), .B0(
        \pixel_buffer[6][5] ), .B1(n611), .Y(n724) );
  CLKINVX1 U783 ( .A(n726), .Y(n725) );
  AOI211X1 U784 ( .A0(n727), .A1(n728), .B0(n729), .C0(n726), .Y(n722) );
  NOR2X1 U785 ( .A(n611), .B(\pixel_buffer[6][5] ), .Y(n726) );
  OAI22XL U786 ( .A0(\pixel_buffer[6][6] ), .A1(n609), .B0(
        \pixel_buffer[6][4] ), .B1(n612), .Y(n729) );
  OAI22XL U787 ( .A0(n730), .A1(n731), .B0(\pixel_buffer[6][3] ), .B1(n627), 
        .Y(n728) );
  NOR2X1 U788 ( .A(n436), .B(n732), .Y(n731) );
  AOI21X1 U789 ( .A0(n732), .A1(n436), .B0(n717), .Y(n730) );
  CLKINVX1 U790 ( .A(n733), .Y(n732) );
  OAI21XL U791 ( .A0(\pixel_buffer[6][0] ), .A1(n631), .B0(
        \pixel_buffer[6][1] ), .Y(n734) );
  NAND2X1 U792 ( .A(\pixel_buffer[6][3] ), .B(n627), .Y(n727) );
  CLKINVX1 U793 ( .A(gray_data[6]), .Y(n610) );
  CLKINVX1 U794 ( .A(gray_data[2]), .Y(n691) );
  OAI21XL U795 ( .A0(n613), .A1(n735), .B0(n740), .Y(n222) );
  MXI2X1 U796 ( .A(n741), .B(n742), .S0(n432), .Y(n740) );
  AOI2BB2X1 U797 ( .B0(\pixel_buffer[4][7] ), .B1(n735), .A0N(n743), .A1N(n744), .Y(n742) );
  ACHCONX2 U798 ( .A(\pixel_buffer[4][6] ), .B(n745), .CI(n737), .CON(n744) );
  AOI32X1 U799 ( .A0(n746), .A1(n612), .A2(\pixel_buffer[7][4] ), .B0(
        \pixel_buffer[7][5] ), .B1(n611), .Y(n745) );
  CLKINVX1 U800 ( .A(n747), .Y(n746) );
  AOI211X1 U801 ( .A0(n748), .A1(n749), .B0(n750), .C0(n747), .Y(n743) );
  NOR2X1 U802 ( .A(n611), .B(\pixel_buffer[7][5] ), .Y(n747) );
  OAI22XL U803 ( .A0(\pixel_buffer[7][6] ), .A1(n609), .B0(
        \pixel_buffer[7][4] ), .B1(n612), .Y(n750) );
  OAI22XL U804 ( .A0(n751), .A1(n752), .B0(\pixel_buffer[7][3] ), .B1(n627), 
        .Y(n749) );
  NOR2X1 U805 ( .A(n436), .B(n753), .Y(n752) );
  AOI21X1 U806 ( .A0(n753), .A1(n436), .B0(n738), .Y(n751) );
  CLKINVX1 U807 ( .A(n754), .Y(n753) );
  OAI21XL U808 ( .A0(\pixel_buffer[7][0] ), .A1(n631), .B0(
        \pixel_buffer[7][1] ), .Y(n755) );
  NAND2X1 U809 ( .A(\pixel_buffer[7][3] ), .B(n627), .Y(n748) );
  OAI22XL U810 ( .A0(n797), .A1(n451), .B0(n796), .B1(n757), .Y(n221) );
  OAI22XL U811 ( .A0(n795), .A1(n451), .B0(n794), .B1(n757), .Y(n220) );
  OAI22XL U812 ( .A0(n793), .A1(n451), .B0(n792), .B1(n757), .Y(n219) );
  OAI22XL U813 ( .A0(n791), .A1(n451), .B0(n790), .B1(n757), .Y(n218) );
  OAI22XL U814 ( .A0(n789), .A1(n451), .B0(n800), .B1(n757), .Y(n217) );
  OAI22XL U815 ( .A0(n788), .A1(n451), .B0(n799), .B1(n757), .Y(n216) );
  OAI22XL U816 ( .A0(n787), .A1(n451), .B0(n798), .B1(n757), .Y(n215) );
  OAI22XL U817 ( .A0(n786), .A1(n451), .B0(n785), .B1(n757), .Y(n214) );
  MXI2X1 U818 ( .A(n760), .B(n761), .S0(n492), .Y(n759) );
  NAND3X1 U819 ( .A(n493), .B(n495), .C(n494), .Y(n762) );
  NOR4X1 U820 ( .A(n763), .B(n495), .C(n494), .D(n493), .Y(n760) );
  NOR4BX1 U821 ( .AN(n434), .B(n766), .C(n477), .D(n478), .Y(n765) );
  NAND3X1 U822 ( .A(n438), .B(n437), .C(n439), .Y(n766) );
  NOR4X1 U823 ( .A(n767), .B(n434), .C(n438), .D(n437), .Y(n764) );
  NAND3BX1 U824 ( .AN(n439), .B(n477), .C(n478), .Y(n767) );
  CLKINVX1 U825 ( .A(N234), .Y(n477) );
  OAI211X1 U826 ( .A0(n768), .A1(n769), .B0(n470), .C0(n419), .Y(N443) );
  OR2X1 U827 ( .A(n579), .B(n483), .Y(n466) );
  NAND2BX1 U828 ( .AN(state[2]), .B(n480), .Y(n769) );
  NOR2X1 U829 ( .A(state[1]), .B(state[0]), .Y(n480) );
  CLKINVX1 U830 ( .A(gray_ready), .Y(n768) );
  LBP_DW01_inc_0_DW01_inc_1 r451 ( .A({1'b0, N164, N163, N162, N161, N160, 
        N159, N158}), .SUM({N186, N193, N192, N191, N190, N189, N188, N187})
         );
  LBP_DW01_inc_1_DW01_inc_2 r456 ( .A({N236, N235, N234, n439, n438, n437, 
        n434}), .SUM({N308, N307, N306, N305, N304, N303, N302}) );
  DFFRX1 \state_reg[1]  ( .D(next_state[1]), .CK(clk), .RN(n801), .Q(state[1]), 
        .QN(n756) );
  DFFRX1 \row_reg[3]  ( .D(n329), .CK(clk), .RN(n801), .Q(N233), .QN(n348) );
  DFFRX1 \row_reg[2]  ( .D(n330), .CK(clk), .RN(n801), .Q(N232), .QN(n346) );
  DFFRX1 \row_reg[1]  ( .D(n331), .CK(clk), .RN(n801), .Q(N231), .QN(n347) );
  DFFRX1 \pixel_buffer_reg[7][0]  ( .D(n223), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[7][0] ), .QN(n739) );
  DFFRX1 \pixel_buffer_reg[5][0]  ( .D(n241), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[5][0] ), .QN(n697) );
  DFFRX1 \pixel_buffer_reg[2][0]  ( .D(n270), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[2][0] ), .QN(n599) );
  DFFRX1 \pixel_buffer_reg[1][0]  ( .D(n278), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[1][0] ), .QN(n594) );
  DFFRX1 \pixel_buffer_reg[0][0]  ( .D(n286), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[0][0] ), .QN(n587) );
  DFFRX1 \pixel_buffer_reg[3][0]  ( .D(n262), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[3][0] ), .QN(n605) );
  DFFRX1 \pixel_buffer_reg[6][0]  ( .D(n232), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[6][0] ), .QN(n718) );
  DFFRX1 \state_reg[0]  ( .D(next_state[0]), .CK(clk), .RN(n801), .Q(state[0]), 
        .QN(n472) );
  DFFRX1 \pixel_buffer_reg[7][6]  ( .D(n229), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[7][6] ), .QN(n737) );
  DFFRX1 \pixel_buffer_reg[5][6]  ( .D(n247), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[5][6] ), .QN(n695) );
  DFFRX1 \pixel_buffer_reg[6][6]  ( .D(n238), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[6][6] ), .QN(n716) );
  DFFRX1 \pixel_buffer_reg[2][5]  ( .D(n275), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[2][5] ), .QN(n597) );
  DFFRX1 \pixel_buffer_reg[1][5]  ( .D(n283), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[1][5] ), .QN(n592) );
  DFFRX1 \pixel_buffer_reg[0][5]  ( .D(n291), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[0][5] ), .QN(n583) );
  DFFRX1 \pixel_buffer_reg[3][5]  ( .D(n267), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[3][5] ), .QN(n603) );
  DFFRX1 \pixel_buffer_reg[2][4]  ( .D(n274), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[2][4] ), .QN(n598) );
  DFFRX1 \pixel_buffer_reg[1][4]  ( .D(n282), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[1][4] ), .QN(n593) );
  DFFRX1 \pixel_buffer_reg[0][4]  ( .D(n290), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[0][4] ), .QN(n585) );
  DFFRX1 \pixel_buffer_reg[3][4]  ( .D(n266), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[3][4] ), .QN(n604) );
  DFFRX1 \read_count_reg[0]  ( .D(n324), .CK(clk), .RN(n801), .Q(read_count[0]), .QN(n600) );
  DFFRX1 \read_count_reg[3]  ( .D(n325), .CK(clk), .RN(n801), .Q(read_count[3]), .QN(n483) );
  DFFRX4 \pixel_buffer_reg[4][3]  ( .D(n257), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[4][3] ), .QN(n627) );
  DFFRX2 \pixel_buffer_reg[4][5]  ( .D(n259), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[4][5] ), .QN(n611) );
  DFFRX2 \pixel_buffer_reg[4][4]  ( .D(n258), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[4][4] ), .QN(n612) );
  DFFRX2 \col_reg[5]  ( .D(n333), .CK(clk), .RN(n801), .Q(N163), .QN(n497) );
  DFFRX2 \col_reg[6]  ( .D(n332), .CK(clk), .RN(n801), .Q(N164), .QN(n498) );
  DFFSX2 \col_reg[0]  ( .D(n338), .CK(clk), .SN(n801), .Q(N158), .QN(n492) );
  DFFRX2 \col_reg[4]  ( .D(n334), .CK(clk), .RN(n801), .Q(N162), .QN(n496) );
  DFFRX2 \pixel_buffer_reg[4][6]  ( .D(n260), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[4][6] ), .QN(n609) );
  DFFRX2 \pixel_buffer_reg[4][7]  ( .D(n261), .CK(clk), .RN(n801), .Q(
        \pixel_buffer[4][7] ), .QN(n607) );
  DFFRX2 \row_reg[5]  ( .D(n327), .CK(clk), .RN(n801), .Q(N235), .QN(n478) );
  MXI2XL U306 ( .A(n485), .B(N443), .S0(read_count[0]), .Y(n324) );
  INVXL U307 ( .A(n872), .Y(n825) );
  INVX12 U308 ( .A(n825), .Y(lbp_valid) );
  INVXL U309 ( .A(n871), .Y(n827) );
  INVX12 U310 ( .A(n827), .Y(gray_req) );
  INVXL U311 ( .A(n857), .Y(n829) );
  INVX12 U312 ( .A(n829), .Y(gray_addr[13]) );
  INVXL U313 ( .A(n858), .Y(n831) );
  INVX12 U314 ( .A(n831), .Y(gray_addr[12]) );
  INVXL U315 ( .A(n859), .Y(n833) );
  INVX12 U316 ( .A(n833), .Y(gray_addr[11]) );
  INVXL U317 ( .A(n860), .Y(n835) );
  INVX12 U318 ( .A(n835), .Y(gray_addr[10]) );
  INVXL U319 ( .A(n861), .Y(n837) );
  INVX12 U320 ( .A(n837), .Y(gray_addr[9]) );
  INVXL U321 ( .A(n862), .Y(n839) );
  INVX12 U596 ( .A(n839), .Y(gray_addr[8]) );
  INVXL U831 ( .A(n863), .Y(n841) );
  INVX12 U832 ( .A(n841), .Y(gray_addr[7]) );
  INVXL U833 ( .A(n864), .Y(n843) );
  INVX12 U834 ( .A(n843), .Y(gray_addr[6]) );
  INVXL U835 ( .A(n865), .Y(n845) );
  INVX12 U836 ( .A(n845), .Y(gray_addr[5]) );
  INVXL U837 ( .A(n866), .Y(n847) );
  INVX12 U838 ( .A(n847), .Y(gray_addr[4]) );
  INVXL U839 ( .A(n867), .Y(n849) );
  INVX12 U840 ( .A(n849), .Y(gray_addr[3]) );
  INVXL U841 ( .A(n868), .Y(n851) );
  INVX12 U842 ( .A(n851), .Y(gray_addr[2]) );
  INVXL U843 ( .A(n869), .Y(n853) );
  INVX12 U844 ( .A(n853), .Y(gray_addr[1]) );
  INVXL U845 ( .A(n870), .Y(n855) );
  INVX12 U846 ( .A(n855), .Y(gray_addr[0]) );
endmodule

