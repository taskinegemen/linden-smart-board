package com.acj.containers.paperClasses
{
	import flash.events.MouseEvent;
	import com.acj.containers.paperClasses.DrawingTool;
	
	public class DrawingToolManager
	{
		/**
		 * Author:  Axel Jensen
		 * Date:	10.21.07
		 * Purpose: dynamically creates a DrawingTool
		 * 
		 * parameters
		 * @className - must extend the com.acj.paperClasses.DrawingTool Class
		 * 
		 * @event - must be a mouse event, used to capture x & y's for starting x&y's of teh DrawingTool;
		 **/
		public static function createTool(className:Class, event:MouseEvent):DrawingTool{
			
			/*
			if( className != DrawingTool ){
				throw new Error('className must extend the DrawingTool class, please check axel.cfwebtools.com and search for "Drawing"');
				return;
			}
			*/
			
			var newClass:DrawingTool = new className();
			
			newClass.startX = event.localX;
	    	newClass.startY = event.localY;
	    	newClass.endX = event.localX;
	    	newClass.endY = event.localY;
	    	
	    	newClass.invalidateDisplayList();
	    	
			return newClass;
		}
	}
}