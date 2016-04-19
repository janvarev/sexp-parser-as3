package com.janvarev.sexptests
{
	
	import com.janvarev.sexpression.SExpReader;
	
	import flashx.textLayout.debug.assert;
	
	import mx.charts.chartClasses.InstanceCache;
	
	import org.flexunit.Assert;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	[TestCase(order=2)]
	public class SReaderTest
	{
		public function SReaderTest(){}
		
		[Before]
		public function runBeforeEveryTest():void {  
		}   
		
		[After]  
		public function runAfterEveryTest():void {   
		} 
		
		
		[Test]  
		public function readInteger():void { 
			var reader:SExpReader = new SExpReader();
			
			var data:Array = [ 	[ 0, "    0" ],
								[ 123, "   123" ],
								[ 1234, "1234" ],
								[ 1, "1" ],
								[ 2, " 2" ],
								[ 234, "234 " ],
								[ 34, "34)" ],
								[ 23, "23(" ] ];
			
			for each (var e:Array in data){
				var li:* = reader.parseSexp(e[1]);
				
				Assert.assertTrue(li is int);
				Assert.assertEquals(li, e[0]);
			}
		}
		
		
		[Test]
		public function readFloat():void{
			var reader:SExpReader = new SExpReader();
			
			var data:Array = [ 	[ 0.1, "    0.1" ],
								[ 12.3, "   12.3" ],
								[ 123.4, "123.4" ],
								[ 1.0, "1.0" ],
								[ 2.7, " 2.7" ],
								[ 23.4, "23.4 " ],
								[ 3.4, "3.4)" ],
								[ 23.45, "23.45(" ] ];
			
			for each (var e:Array in data){
				var li:* = reader.parseSexp(e[1]);

				Assert.assertTrue(li is Number);
				Assert.assertEquals(li, e[0]);
			}
		}
		
		
		[Test]  
		public function readString():void { 
			var reader:SExpReader = new SExpReader();
			
			var data:Array = [ 	[ "   0", " \"   0\"" ],
								[ "123", "   \"123\"" ],
								[ "One  ", "\"One  \"" ],
								[ "Two", "\"Two\")" ],
								[ "Two (three)", "\"Two (three)\")" ],
								[ "Test\"2", "\"Test\\\"2\")" ],
								[ "Test", "\"Test\"(" ] ];
			
			for each (var e:Array in data){
				var li:* = reader.parseSexp(e[1]);
				
				Assert.assertTrue(li is String);
				Assert.assertEquals(li, e[0]);
			}
			
			try{
				reader.parseSexp("\" one ");
				assertTrue(false);
			}
			catch(err:Error){
				assertEquals(err.message, "Quote expected!");
			}
			
		}
		
		[Test]
		public function readList():void{
			
			var reader:SExpReader = new SExpReader();
			
			var o:* = reader.parseSexp("()");
			assertTrue(o is Array);
			assertTrue((o as Array).length == 0);
			
			o = reader.parseSexp("( )");
			assertTrue(o is Array);
			assertTrue((o as Array).length == 0);
			
			o = reader.parseSexp("(123)");
			assertTrue(o is Array);
			assertTrue((o as Array).length == 1);
			assertTrue((o as Array)[0] == 123);
			
			
			o = reader.parseSexp("(1 2 3)");
			assertTrue(o is Array);
			assertTrue((o as Array).length == 3);
			assertTrue((o as Array)[0] == 1);
			assertTrue((o as Array)[1] == 2);
			assertTrue((o as Array)[2] == 3);
			
			
			o = reader.parseSexp("(1 (2) 3)");
			assertTrue(o is Array);
			assertTrue((o as Array).length == 3);
			assertTrue((o as Array)[0] == 1);
			var o2:Array = (o as Array)[1];
			assertTrue(o2[0] == 2);
			assertTrue((o as Array)[2] == 3);	
			
			o = reader.parseSexp("((1))");
			assertTrue(o is Array);
			assertTrue((o as Array).length == 1);
			var o3:Array = (o as Array)[0];
			assertTrue(o3[0] == 1);
			
			o = reader.parseSexp("(1 \"test\" 3)");
			assertTrue(o is Array);
			assertTrue((o as Array).length == 3);
			assertTrue((o as Array)[0] == 1);
			assertTrue((o as Array)[1] == "test");
			assertTrue((o as Array)[2] == 3);
			
			o = reader.parseSexp("(1 \"test\" 3)", true);
			assertTrue(o is Array);
			assertTrue((o as Array).length == 3);
			assertTrue((o as Array)[0] == 1);
			assertTrue((o as Array)[1] == "test");
			assertTrue((o as Array)[2] == 3);
			
			o = reader.parseSexp("(1 test 3)");
			assertTrue(o is Array);
			assertTrue((o as Array).length == 3);
			assertTrue((o as Array)[0] == 1);
			assertTrue((o as Array)[1] == "test");
			assertTrue((o as Array)[2] == 3);
			
			o = reader.parseSexp("(1 test 3)", true);
			assertTrue(o is Array);
			assertTrue((o as Array).length == 3);
			assertTrue((o as Array)[0] == 1);
			assertTrue((o as Array)[1] == "__test");
			assertTrue((o as Array)[2] == 3);
		}
		
		[Test]
		public function serializeList():void{
			
			var reader:SExpReader = new SExpReader();
		
			var o:*;
			var sto:String;
			
			o = reader.parseSexp('(+ a 2 (c "da"))');
			sto = reader.serializeSexp(o);
			assertEquals(sto, '(+ a 2 (c da))'); // dequote da standart text
			
			o = reader.parseSexp('(+ a 2 (c "русский"))'); // non-english text
			sto = reader.serializeSexp(o);
			assertEquals(sto, '(+ a 2 (c "русский"))'); 
			
			o = reader.parseSexp('(+ a 2 (c "da"))', true);
			sto = reader.serializeSexp(o, true);
			assertEquals(sto, '(+ a 2 (c "da"))');
			
			o = reader.parseSexp('(+ a 2 (c "da"))', true);
			sto = reader.serializeSexp(o);
			assertEquals(sto, '(__+ __a 2 (__c da))');
		}
	}
}