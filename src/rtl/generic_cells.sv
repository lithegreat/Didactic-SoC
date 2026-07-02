/*
  Project: Edu4Chip
  Module(s): generic_and
  Contributors:
    * Paul R. Genssler (paul.genssler@tum.de)
  Description:
    * Logic and gate to instantiate in kactus
*/

module generic_and
  (
    input  logic a,
    input  logic b,
    output logic c
  );

  assign c = a & b;

endmodule
