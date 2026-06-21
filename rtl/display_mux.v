//=============================================================
// Module: display_mux
// Purpose: Time-multiplexes 6 digits (HH:MM:SS) across one set of
//          seven-segment pins + 6 anode select lines
//=============================================================
module display_mux (
    input  wire       clk,
    input  wire       rst,
    input  wire [4:0] hour,
    input  wire [5:0] min,
    input  wire [5:0] sec,
    output reg  [6:0] seg,
    output reg  [5:0] an        // active-low anode select, 6 digits
);

    reg [16:0] refresh_count; // ~1kHz mux refresh from 50MHz clk
    reg [2:0]  digit_sel;
    reg [3:0]  bcd_digit;

    wire [3:0] h_tens = hour / 10;
    wire [3:0] h_ones = hour % 10;
    wire [3:0] m_tens = min  / 10;
    wire [3:0] m_ones = min  % 10;
    wire [3:0] s_tens = sec  / 10;
    wire [3:0] s_ones = sec  % 10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_count <= 17'd0;
            digit_sel     <= 3'd0;
        end else if (refresh_count == 17'd99_999) begin
            refresh_count <= 17'd0;
            digit_sel     <= (digit_sel == 3'd5) ? 3'd0 : digit_sel + 1'b1;
        end else begin
            refresh_count <= refresh_count + 1'b1;
        end
    end

    always @(*) begin
        case (digit_sel)
            3'd0: begin bcd_digit = s_ones; an = 6'b111110; end
            3'd1: begin bcd_digit = s_tens; an = 6'b111101; end
            3'd2: begin bcd_digit = m_ones; an = 6'b111011; end
            3'd3: begin bcd_digit = m_tens; an = 6'b110111; end
            3'd4: begin bcd_digit = h_ones; an = 6'b101111; end
            3'd5: begin bcd_digit = h_tens; an = 6'b011111; end
            default: begin bcd_digit = 4'd0; an = 6'b111111; end
        endcase
    end

    seg_decoder u_seg_decoder (
        .digit (bcd_digit),
        .seg   (seg)
    );

endmodule