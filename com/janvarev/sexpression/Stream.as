package com.janvarev.sexpression
{
	
	public class Stream
	{
		
		private var _val:String;
		private var _pos:int = 0;
		
		public function Stream(val:String)
		{
			super();
			this._val = val;	
		}
		
		public function get peek():String{
			return _val.charAt(_pos);	
		}
		
		public function next():void{
			_pos++;
		}
		
		public function get atEnd():Boolean{
			return _pos >= _val.length;
		}
		
		public function skipSeparators():void{
			while(isSeparator(peek)){
				next();
			}
		}
		
		private function isSeparator(s:String):Boolean{
			return s == " " || s == "\t" || s == "\r" || s == "\n";
		}
		
	}
}