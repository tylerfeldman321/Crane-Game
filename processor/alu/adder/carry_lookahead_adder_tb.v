`timescale 1 ns / 100 ps
module carry_lookahead_adder_tb;
    wire [31:0] a, b;

    wire [31:0] sum, and_result, or_result;
    wire cout;

    wire subtraction, isNotEqual, isLessThan, overflow;
    
    integer s = 0;
    assign subtraction = s;

    carry_lookahead_adder cla(a, b, subtraction, sum, and_result, or_result, isNotEqual, isLessThan, overflow); 

    integer failed = 0;
    integer total = 0;
    integer max_val = 147483647;
    integer i = 0;
    integer j = 0;
    assign a = $signed(i);
    assign b = $signed(j);
    
    initial begin

        $display("--------------- STARTING TESTS FOR ADDITION ---------------");
        // Test if sum is correct for a bunch of combinations
        for(i = 0; i < 247483647; i = i + 47483647) begin
            for(j = 0; j < 247483647; j = j + 47483647) begin
                #10;
                if ((sum === a + b) && (overflow == (a+b)>=2147483648)) begin
                    $display("PASSED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)>=2147483648);
                end else begin
                    $display("FAILED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)>=2147483648);
                    failed = failed + 1;
                end
                total = total + 1;
            end
        end

        $display("--------------- STARTING TESTS FOR SUBTRACTION ---------------");

        s = 1;
        for(i = 0; i < 247483647; i = i + 47483647) begin
            for(j = 0; j < 247483647; j = j + 47483647) begin
                #10;
                if ((sum === $unsigned(a - b)) && (isNotEqual == (a != b) && (isLessThan == (a < b)))) begin
                    $display("PASSED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b, isNotEqual:%b, isNotEqual_expected:%b, isLessThan:%b, isLessThan_expected:%b", 
                                                            a, b, sum, a-b, overflow, (a-b)<-2147483648, isNotEqual, (a != b), isLessThan, a < b);
                end else begin
                    $display("FAILED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b, isNotEqual:%b, isNotEqual_expected:%b, isLessThan:%b, isLessThan_expected:%b", 
                                                            a, b, sum, a-b, overflow, (a-b)<-2147483648, isNotEqual, (a != b), isLessThan, a < b);
                    failed = failed + 1;
                end
                total = total + 1;
            end
        end
        $display("Number Of Cases Failed:%d, Total:%d", failed, total);

        
        $display("--------------- STARTING TESTS FOR isNotEqual AND isLessThan AND overflow ---------------");

        // Test isNotEqual
        s = 1;
        i = 1000;
        j = 1000;
        #20;
        if (isNotEqual == (a != b) && isLessThan == (a < b)) begin
            $display("PASSED: a:%b, b:%b, sum:%b, sum_expected:%b, isNotEqual:%b, isLessThan:%b", a, b, sum, a-b, isNotEqual, isLessThan);
        end else begin
            $display("FAILED: a:%b, b:%b, sum:%b, sum_expected:%b, isNotEqual:%b, isLessThan:%b", a, b, sum, a-b, isNotEqual, isLessThan);
        end


        s = 1;
        i = 1000;
        j = 1001;
        #20;
        if ((isNotEqual == (a != b)) && (isLessThan == (a < b))) begin
            $display("PASSED: a:%b, b:%b, sum:%b, sum_expected:%b, isNotEqual:%b, isLessThan:%b", a, b, sum, a-b, isNotEqual, isLessThan);
        end else begin
            $display("FAILED: a:%b, b:%b, sum:%b, sum_expected:%b, isNotEqual:%b, isLessThan:%b", a, b, sum, a-b, isNotEqual, isLessThan);
        end

        s = 1;
        i = 1000;
        j = 999;
        #20;
        if ((isNotEqual == (a != b)) && (isLessThan == (a < b))) begin
            $display("PASSED: a:%b, b:%b, sum:%b, sum_expected:%b, isNotEqual:%b, isLessThan:%b", a, b, sum, a-b, isNotEqual, isLessThan);
        end else begin
            $display("FAILED: a:%b, b:%b, sum:%b, sum_expected:%b, isNotEqual:%b, isLessThan:%b", a, b, sum, a-b, isNotEqual, isLessThan);
        end
        
        s = 0;
        i = 2147483647;
        j = 0;
        #20;
        if (overflow == ((a+b)>=2147483648) || overflow == ((a+b) < -2147483648)) begin
            $display("PASSED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)>=2147483648);
        end else begin
            $display("FAILED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)>=2147483648);
        end

        s = 0;
        i = 2147483647;
        j = 1;
        #20;
        if (overflow == ((a+b)>=2147483648) || overflow == ((a+b) < -2147483648)) begin
            $display("PASSED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)>=2147483648);
        end else begin
            $display("FAILED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)>=2147483648);
        end

        s = 0;
        i = -2147483647;
        j = -1;
        #20;
        if (overflow == ((a+b)>=2147483648) || overflow == ((a+b) < -2147483648)) begin
            $display("PASSED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)<-2147483648);
        end else begin
            $display("FAILED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)<-2147483648);
        end

        s = 0;
        i = -2147483647;
        j = -22;
        #20;
        if (overflow == ((a+b)>=2147483648) || overflow == ((a+b) < -2147483648)) begin
            $display("PASSED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)<-2147483648);
        end else begin
            $display("FAILED: a:%b, b:%b, sum:%b, sum_expected:%b, overflow:%b, overflow_expected:%b", a, b, sum, a+b, overflow, (a+b)<-2147483648);
        end
        

        $finish;
    end

endmodule 