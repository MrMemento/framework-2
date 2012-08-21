
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
try
{
	// Test existing instance.
	var dummy = FlashMouseWheelTrap;
	dummy     = undefined;
	delete dummy;
}
catch ( error_ )
{
	/**
	 * SINGLETON GLOBAL instance to be used by Flash mousewheel capturing.
	 */
	FlashMouseWheelTrap = new function FlashMouseWheelTrap( )
	{
		/**
		 * PUBLIC Property to switch capturing of mouse wheel events.
		 */
		this.enabled = false;

		/**
		 * PRIVATE Function for handling browser events.
		 */
		var wheelHandler = function FlashMouseWheelTrap_wheelHandler( event )
		{
			if ( FlashMouseWheelTrap.enabled )
			{
				if ( !event )
				{
					event = window.event;
				}

				if ( event.preventDefault )
				{
					event.preventDefault( );
				}
				if ( event.returnValue )
				{
					event.returnValue = false;
				}
				return false;
			}
		};

		/**
		 * CONSTRUCTOR Initialize event handling.
		 */
		if ( window.attachEvent )
		{
			window.attachEvent( 'onmousewheel', wheelHandler );
		}
		if ( document.attachEvent )
		{
			document.attachEvent( 'onmousewheel', wheelHandler );
		}
		if ( window.addEventListener )
		{
			window.addEventListener( 'DOMMouseScroll', wheelHandler, false );
			window.addEventListener( 'mousewheel',     wheelHandler, false );
		}
		if ( document.addEventListener )
		{
			document.addEventListener( 'DOMMouseScroll', wheelHandler, false );
			document.addEventListener( 'mousewheel',     wheelHandler, false );
		}
		window.onmousewheel   = wheelHandler;
		document.onmousewheel = wheelHandler;
	}( );
}
