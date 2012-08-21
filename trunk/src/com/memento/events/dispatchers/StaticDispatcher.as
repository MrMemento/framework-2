﻿/** * Copyright 2011 by Barnabás Bucsy * * This file is part of The Memento Framework. * * The Memento Framework is free software: you can redistribute it * and/or modify it under the terms of the GNU Lesser General Public * License as published by the Free Software Foundation, either * version 3 of the License, or (at your option) any later version. * * The Memento Framework is distributed in the hope that it will be * useful, but WITHOUT ANY WARRANTY; without even the implied warranty * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU * Lesser General Public License for more details. * * You should have received a copy of the GNU Lesser General Public * License along with The Memento Framework. If not, see * <http://www.gnu.org/licenses/>. */package com.memento.events.dispatchers{	import flash.events.Event;	import flash.events.EventDispatcher;	/**	 * STATIC Base Class for static Classes dispatching events.	 * @see flash.utils.Proxy;	 * @see flash.events.EventDispatcher;	 */	public class StaticDispatcher	{		/**		 * Instance of EventDispatcher.		 */		protected static var __dispatcher:EventDispatcher = new EventDispatcher;		/**		 * Static replacement for addEventListener() function.		 *		 * @copy EventDispatcher#addEventListener		 */		public static function addEventListener(			type_:String,			listener_:Function,			useCapture_:Boolean       = false,			priority_:int             = 0,			useWeakReference_:Boolean = false		):void		{			__dispatcher.addEventListener(				type_,				listener_,				useCapture_,				priority_,				useWeakReference_			);		}		/**		 * Static replacement for removeEventListener() function.		 *		 * @copy EventDispatcher#removeEventListener		 */		public static function removeEventListener(			type_:String,			listener_:Function,			useCapture_:Boolean = false		):void		{			__dispatcher.removeEventListener( type_, listener_, useCapture_ );		}		/**		 * Static replacement for dispatchEvent() function.		 *		 * @copy EventDispatcher#dispatchEvent		 */		public static function dispatchEvent( event_:Event ):Boolean		{			return __dispatcher.dispatchEvent( event_ );		}		/**		 * Static replacement for hasEventListener() function.		 *		 * @copy EventDispatcher#hasEventListener		 */		public static function hasEventListener( type_:String ):Boolean		{			return __dispatcher.hasEventListener( type_ );		}		/**		 * Static replacement for willTrigger() function.		 *		 * @copy EventDispatcher#willTrigger		 */		public static function willTrigger( type_:String ):Boolean		{			return __dispatcher.willTrigger( type_ );		}	}}