
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
	var dummy = FlashBackspaceTrap;
	dummy     = undefined;
	delete dummy;
}
catch ( error_ )
{
	/**
	 * SINGLETON GLOBAL instance to be used by Flash backspace capturing.
	 */
	FlashBackspaceTrap = new function FlashBackspaceTrap( )
	{
		/**
		 * PUBLIC Property to switch capturing of mouse wheel events.
		 */
		this.enabled = false;

		/**
		 * PRIVATE Function for handling browser events.
		 */
		var backspaceHandler = function FlashBackspaceTrap_backspaceHandler( event )
		{
			if ( FlashBackspaceTrap.enabled )
			{
				if ( !event )
				{
					event = window.event;
				}

				var keyCode = event.keyCode !== undefined ? event.keyCode : event.charCode;
				if ( keyCode == 8 )
				{
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
			}
		};

		/**
		 * CONSTRUCTOR Initialize event handling.
		 */
		if ( window.attachEvent )
		{
			window.attachEvent( 'onkeydown',  backspaceHandler );
			window.attachEvent( 'onkeypress', backspaceHandler );
		}
		if ( document.attachEvent )
		{
			document.attachEvent( 'onkeydown',  backspaceHandler );
			document.attachEvent( 'onkeypress', backspaceHandler );
		}
		if ( window.addEventListener )
		{
			window.addEventListener( 'keydown',  backspaceHandler, false );
			window.addEventListener( 'keypress', backspaceHandler, false );
		}
		if ( document.addEventListener )
		{
			document.addEventListener( 'keydown',  backspaceHandler, false );
			document.addEventListener( 'keypress', backspaceHandler, false );
		}
		window.onkeydown    = backspaceHandler;
		window.onkeypress   = backspaceHandler;
		document.onkeydown  = backspaceHandler;
		document.onkeypress = backspaceHandler;
	}( );
}
