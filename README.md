# sexp-parser-as3
S-expression parser for ActionScript 3

Parse and serialize S-expressions (https://en.wikipedia.org/wiki/S-expression) to array structure.
Designed for use to make Domain-Specific Languages on S-expressions.

Parser support two modes, which differs in parsing identifiers:
* *isAddPrefixToSymbols = false* - standart, converts (1 (2 3) test "teststr" c) to [1,[2,3],"test","teststr","c"]
* *isAddPrefixToSymbols = true* - converts (1 (2 3) test "teststr" c) to [1,[2,3],"__test","teststr","__c"], add __ to unquoted identifiers. Allows differ identifiers from strings in interpreter.

Demo (for JS identical library): http://d.janvarev.ru/sexp/sexp-parser-tsjs/

Use:
```
var reader:SExpReader = new SExpReader();
var o:*;
o = reader.parseSexp('(1 (2 3) test "teststr" c)');
```
o will be like JSON structure [1,[2,3],"test","teststr","c"]
