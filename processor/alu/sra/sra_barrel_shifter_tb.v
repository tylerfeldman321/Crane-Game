`timescale 1 ns / 100 ps
module sra_barrel_shifter_tb;
    wire [31:0] data_in;
    wire [4:0] ctrl_shiftamt;

    wire [31:0] data_out;

    sra_barrel_shifter shifter(data_in, ctrl_shiftamt, data_out); 
    
    // assign data_in = 1234;
    assign data_in = -100040;

    integer i;
    assign ctrl_shiftamt = i;
    
    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            #20;
            if (data_out === $unsigned($signed(data_in) >>> i)) begin
                $display("PASSED: data_in:%b, ctrl_shiftamt:%b, data_out:%b, expected:%b", data_in, ctrl_shiftamt, data_out, $unsigned($signed(data_in) >>> i));
            end else begin
                $display("FAILED: data_in:%b, ctrl_shiftamt:%b, data_out:%b, expected:%b", data_in, ctrl_shiftamt, data_out, $unsigned($signed(data_in) >>> i));
            end
        end
        $finish;
    end

    initial begin
        $dumpfile("sra_barrel_shifter_wave.vcd");
        $dumpvars(0, sra_barrel_shifter_tb);
    end
endmodule 