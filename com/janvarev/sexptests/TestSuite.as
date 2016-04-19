package com.janvarev.sexptests
{
	import org.flexunit.runners.Suite;
	
	

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite
	{
		public var t1:SReaderTest;
		public var t2:StreamTest;
		
		public function TestSuite(){}
	}
}