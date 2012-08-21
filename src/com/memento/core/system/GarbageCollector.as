
/**
 * Copyright 2011 by Barnabás Bucsy
 *
 * This file is part of The Memento Framework.
 *
 * The Memento Framework is free software: you can redistribute it
 * and/or modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or (at your option) any later version.
 *
 * The Memento Framework is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with The Memento Framework. If not, see
 * <http://www.gnu.org/licenses/>.
 */
package com.memento.core.system
{
	import com.memento.utils.ClassUtil;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Class for emptying other Classes' disposable pools.
	 * @author Barnabás Bucsy (Lobo)
	 */
	public class GarbageCollector
	{
		private static const __DISPOSE_FUNCTION:String = 'dispose';

		/**
		 * Object containing registered Classes.
		 */
		private static var __disposables:Object = { };

		/**
		 * Number of registered Classes.
		 */
		private static var __disposablesLength:uint = 0;

		/**
		 * Has disposing process been initiated.
		 */
		private static var __started:Boolean = false;

		/**
		 * Timer for disposing interval.
		 */
		private static var __timer:Timer = new Timer( 7200000 );

		/**
		 * Constructor
		 * @throws Error Static Class.
		 */
		public function GarbageCollector( ):void
		{
			throw new Error( 'Tried to instantiate static class!' );
		}

		/**
		 * Function for registering disposable Classes.
		 * @param class_ Class The Class to register.
		 * @throws Error Throws error if Class does not have static dispose() function.
		 * @throws Error Throws error if Class is already registered.
		 */
		public static function register( class_:Class ):void
		{
			var className:String = ClassUtil.getClassName( class_ );

			if ( !class_[ __DISPOSE_FUNCTION ] || !( class_[ __DISPOSE_FUNCTION ] is Function ) )
			{
				throw new Error( 'Class must have static dispose() Function: ' + className );
			}

			if ( __disposables[ className ] )
			{
				throw new Error( 'Tried to re-register Class: ' + className );
			}

			__disposables[ className ] = class_;
			__disposablesLength++;
			if ( __started && !__timer.running )
			{
				__timer.start( );
			}
		}

		/**
		 * Function for unregistering disposable Classes.
		 * @param class_ Class The Class to unregister.
		 * @throws Error Throws error if Class does not have static dispose() function.
		 * @throws Error Throws error if Class already registered.
		 */
		public static function unregister( class_:Class ):void
		{
			var className:String = ClassUtil.getClassName( class_ );

			if ( !__disposables[ className ] )
			{
				throw new Error( 'Tried to unregister unexisting Class: ' + className );
			}

			delete __disposables[ className ];
			__disposablesLength--;
			if ( __timer.running && __disposablesLength == 0 )
			{
				__timer.reset( );
			}
		}

		/**
		 * Start disposing process.
		 * @param delayMS_ Disposing delay in milliseconds. Default is 7200000 (2 mins).
		 * @throws Error Throws Error if delay is set to zero.
		 */
		public static function start( delayMS_:uint = 7200000 ):void
		{
			if ( delayMS_ == 0 )
			{
				throw new Error( 'Delay argument can not be zero!' );
			}

			__started     = true;
			__timer.delay = delayMS_;

			// this may be the first start
			if ( !__timer.hasEventListener( TimerEvent.TIMER ) )
			{
				__timer.addEventListener( TimerEvent.TIMER, dispose );
			}

			if (  !__timer.running && __disposablesLength > 0 )
			{
				__timer.start( );
			}
		}

		/**
		 * Stop disposing process.
		 */
		public static function stop( ):void
		{
			__started = false;
			if ( __timer.running )
			{
				__timer.reset( );
			}
		}

		/**
		 * Function for disposing all registered instances. Also used as Timer listener.
		 * @param event_ TimerEvent
		 */
		public static function dispose( event_:Event = null ):void
		{
			for ( var label:String in __disposables )
			{
				__disposables[ label ].dispose( );
			}
		}
	}
}
