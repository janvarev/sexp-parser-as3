package com.janvarev.sexpression
{
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;

	public class SExpReader
	{
		
		private var isAddPrefixToSymbols:Boolean = false;
		
		public function SExpReader()
		{
		}
		
		public function parseSexp(str:String, isAddPrefixToSymbols:Boolean = false):* {
			this.isAddPrefixToSymbols = isAddPrefixToSymbols;
			return readStream(new Stream(str));	
		}

		public function serializeSexp(sexp:*, isAddPrefixToSymbols:Boolean = false):String {
			this.isAddPrefixToSymbols = isAddPrefixToSymbols;
			return serialize(sexp);
		}
		
		private var regAlnum:RegExp = /[^A-Za-z0-9\+\-\=\*\?\_]/g;
		
		private function serialize(sexp:*):String {
			if(sexp is Array) {
				var ar:Vector.<String> = new Vector.<String>;
				for(var i:int = 0; i < (sexp as Array).length; i++) {
					ar.push(serialize((sexp as Array)[i]));
				}
				return "("+ar.join(" ")+")";
			} else {
				if(sexp is Number) {
					return (sexp as Number).toString();
				}
				if(sexp is String) {
					// several cases
					var s:String = sexp;
					if(isAddPrefixToSymbols) { // isAddPrefix mode?
						if(s.substr(0,2) == "__") { // symbol return non-quoted
							return s.substr(2);
						} else { // other return quoted
							s = strReplace("\\", "\\\\", s);
							s = strReplace("\"", "\\\"", s);
							return '"'+s+'"';
						}
					} else { // no add prefix mode
						if(s.match(regAlnum).length > 0 // some non-latin chars or digits? 
							|| s.length == 0) { // or just ""?
							s = strReplace("\\", "\\\\", s);
							s = strReplace("\"", "\\\"", s);
							return '"'+s+'"'; // return quoted
						} else {
							return s; // return non-quoted
						}
					}
				}
			}
			return "";
		}
		
		public static function strReplace(replaceFrom:String, replaceTo:String, content:String): String {
			var tArr: Array = content.split(replaceFrom);
			
			return tArr.join(replaceTo);
		} 
		
		private function readStream(stream:Stream):*{
			
			stream.skipSeparators();
			// comments
			if(stream.peek == ";"){
				stream.next();
				
				while(stream.peek != "\n" && stream.peek != "\r" ){
					if(stream.atEnd){
						break;
					}
					
					stream.next();
				}

				stream.next();
				return readStream(stream);				
			}
			
			// ( - list
			if(stream.peek == "("){
				stream.next();
				return readListRest(stream);
			}
			// atom
			return readAtom(stream);
		}
	
		
		
		private function readListRest(stream:Stream):*{
			stream.skipSeparators();
			
			if(stream.atEnd){
				throw new Error("missing ')'")
			}
			
			if(stream.peek == ")"){
				stream.next();
				return new Array();
			}
			
			var element:*;
			var restElement:*;
			
			element = readStream(stream);
			
			stream.skipSeparators();
			
			var lc:Array = new Array();
			
			if(stream.peek == ")"){
				stream.next();				
				lc[0] = element;
				return lc;
			}
			
			lc = readListRest(stream);
			sexpConsToRest(element,lc);
			
			return lc;
			
		}
		
		public static function sexpConsToRest(first:*, rest:*):void {
			(rest as Array).splice(0,0,first);
		}
		
		private function readAtom(stream:Stream):*{
			var buffer:String = "";
			
			stream.skipSeparators();
			
			// String
			if(stream.peek == "\""){
				stream.next();
				
				while(stream.peek != "\""){
					if(stream.atEnd){
						throw new Error("Quote expected!");
					}
					if(stream.peek != "\\") {
						buffer += stream.peek;
					} else {
						// just add escaped symbol
						stream.next(); 
						buffer += stream.peek;
					}
					stream.next();
				}
				
				stream.next();
				
				return buffer;
			}
			
			// read up do separators
			while(!stream.atEnd && stream.peek!=" " && stream.peek!="(" && stream.peek!=")" && stream.peek != "\t" && stream.peek != "\n" && stream.peek != "\r" ){
				buffer += stream.peek;
				stream.next();
			}
			
			// is number?
			if(!isNaN(parseFloat(buffer))){
				var num:Number = new Number(buffer);
				// is int?
				if(buffer.indexOf(".") == -1){
					return int(num);
				} else{
					return num;
				}
			}
			
			if(isAddPrefixToSymbols) {
				return "__"+ buffer;
			}
			
			return buffer;

				
		}

		
	}
}