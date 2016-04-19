package com.janvarev.sexptests
{
	import com.janvarev.sexpression.Stream;
	
	import org.flexunit.asserts.assertEquals;
	
	

	[TestCase(order=1)]
	public class StreamTest
	{
		public function StreamTest()
		{
		}
		
		[Test]
		public function testPeekAndNextAndAtEnd():void{
			var s:Stream = new Stream("One Two");
			
			assertEquals(s.peek, "O");
			
			while(!s.atEnd){
				s.next()
			}
			assertEquals(s.peek, "");
			
		}
		
		[Test]
		public function testSkipSeparators():void{
			var s:Stream = new Stream("   Two");
			
			s.skipSeparators();
			assertEquals("T", s.peek);
		}
	}
}