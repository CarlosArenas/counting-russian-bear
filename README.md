counting-russian-bear
=====================

Generate custodian Bates ranges

Usage
-----

`ruby rangify.rb list_of_documents.csv > custodian_ranges.csv`

Description
-----------

Assuming the input file is a CSV file with:

1. beginning Bates number
2. end Bates number
3. custodian

values (in that order), this script generates custodian ranges of consecutive documents (in CSV format).

Output is sorted by custodian.
