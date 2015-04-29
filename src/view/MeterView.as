package view 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class MeterView extends Sprite
	{	
		
		protected var m_count:int	// The level of this meter to display (a number between 0 and 10)
		
		// Sprites
		protected var m_cover:Sprite		// The cover
		
		public function MeterView() 
		{
			m_count = 0;
			draw();
		}
		
		public function set count(val:int):void
		{
			m_count = val;
			adjustCover();
		}
		
		/**
		 *	Draw the meter (required upon creating for the first time)
		 * 
		**/
		private function draw():void
		{
			// Draw rectangle background
			graphics.beginFill(Constants.METER_BACKGROUND_COLOR);
			graphics.drawRect(0, 0, Constants.METER_WIDTH, Constants.METER_HEIGHT);
			graphics.endFill();
			
			// Draw Filled Level
			graphics.beginFill(Constants.METER_LEVEL_COLOR);
			graphics.drawRect(Constants.METER_RULER_WIDTH, 0, Constants.METER_WIDTH - Constants.METER_RULER_WIDTH, Constants.METER_HEIGHT);
			graphics.endFill();
			
			// Draw Ruler Lines
			
			
			var gap:int = Constants.METER_HEIGHT / 10;
			for (var i:int = 1; i < 10; i++)
			{
				if (i % 2 == 0)
				{
					graphics.lineStyle(2 * Constants.METER_LINES_TICKNESS, Constants.METER_LINES_COLOR, 1);
					graphics.beginFill(Constants.METER_LINES_COLOR);
				}
				else
				{
					graphics.lineStyle(Constants.METER_LINES_TICKNESS, Constants.METER_LINES_COLOR, 1);
					graphics.beginFill(Constants.METER_LINES_COLOR);
				}
				graphics.moveTo(0, i * gap);
				graphics.lineTo(Constants.METER_RULER_WIDTH, i * gap)
				graphics.endFill();
			}
			
			
			// Draw Cover
			m_cover = new Sprite();
			m_cover.graphics.beginFill(Constants.METER_BACKGROUND_COLOR);
			m_cover.graphics.drawRect(0, 0, Constants.METER_WIDTH - Constants.METER_RULER_WIDTH, Constants.METER_HEIGHT);
			m_cover.graphics.endFill();
			
			m_cover.x = Constants.METER_RULER_WIDTH;
			m_cover.y = 0;
			
			adjustCover();
			
			addChild(m_cover);
		}
		
		/**
		 *	Adjusts the size of the cover to show the proper charge
		 * 
		**/
		private function adjustCover():void
		{
			m_cover.height = Constants.METER_HEIGHT - m_count * Constants.METER_HEIGHT / 10
		}
		
	}
}