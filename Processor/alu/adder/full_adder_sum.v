module full_adder_sum(sum, a, b, cin);
    input a, b, cin;
    output sum;
    xor Sresult(sum, a, b, cin);
endmodule