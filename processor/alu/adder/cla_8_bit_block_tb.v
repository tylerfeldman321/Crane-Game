`timescale 1 ns / 100 ps
module cla_8_bit_block_tb;
    wire [7:0] a, b;
    wire cin;
    assign cin = 1;

    wire [7:0] sum;
    wire cout;

    cla_8_bit_block cla(sum, cout, a, b, cin); 

    integer failed = 0;
    integer total = 0;
    integer max_val = 256;
    integer i = 0;
    integer j = 0;
    assign a = i;
    assign b = j;
    
    initial begin
        for(i = 0; i < max_val; i = i + 1) begin
            for(j = 0; j < max_val; j = j + 1) begin
                #20;
                if ((sum === a + b + cin) && (cout == ((a + b + cin) >= max_val))) begin
                    $display("PASSED: a:%b, b:%b, cin:%b, sum:%b, cout:%b, sum_expected:%b, cout_expected:%b", a, b, cin, sum, cout, a+b, (a + b + cin) >= max_val);
                end else begin
                    $display("FAILED: a:%b, b:%b, cin:%b, sum:%b, cout:%b, sum_expected:%b cout_expected:%b", a, b, cin, sum, cout, a+b, (a + b + cin) >= max_val);
                    failed = failed + 1;
                end
                total = total + 1;
            end
        end
        $display("Number Of Cases Failed:%d, Total:%d", failed, total);
        $finish;
    end

endmodule 