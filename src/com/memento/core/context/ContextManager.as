
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
package com.memento.core.context
{
	import com.memento.constants.net.URLTargets;
	import com.memento.core.net.getURL;
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * Class for managing ContextMenus in ActionScript.
	 * @author Barnabás Bucsy (Lobo)
	 */
	public class ContextManager
	{
		/**
		 * Constructor
		 * @throws Error Static Class.
		 */
		public function ContextManager( ):void
		{
			throw new Error( 'Tried to instantiate static class!' );
		}

		/**
		 * Hides all possible context items.
		 * @param target_ InteractiveObject Target InteractiveObject to modify ContextMenu.
		 */
		public static function clearContext( target_:InteractiveObject ):void
		{
			if ( !target_.contextMenu )
			{
				target_.contextMenu = new ContextMenu( );
			}
			target_.contextMenu.customItems.length = 0;
			target_.contextMenu.hideBuiltInItems( );
		}

		/**
		 * Adds custom ContextMenuItem to target InteractiveObject.
		 * @param target_ InteractiveObject Target InteractiveObject to modify ContextMenu.
		 * @param label_ String The caption of the new ContextMenuItem.
		 * @param callback_ Function A Function to be used when ContextMenuItem is selected. If null, item will be disabled.
		 * @param separator_ Boolean Whether to use a separator before item.
		 * @param position_ The position to add the item. -1 means add to the end.
		 */
		public static function addMenuItem( target_:InteractiveObject, label_:String, callback_:Function = null, separator_:Boolean = false, position_:int = -1 ):void
		{
			if ( !target_.contextMenu )
			{
				target_.contextMenu = new ContextMenu( );
			}

			var item:ContextMenuItem = new ContextMenuItem( label_, separator_, callback_ != null );
			if ( callback_ != null )
			{
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, callback_ );
			}

			if ( position_ < 0 )
			{
				target_.contextMenu.customItems.push( item );
			}
			else
			{
				target_.contextMenu.customItems.splice( position_, 0, item );
			}
		}

		/**
		 * Adds custom ContextMenuItem to target InteractiveObject that navigates to an URL.
		 * @param target_ InteractiveObject Target InteractiveObject to modify ContextMenu.
		 * @param label_ String The caption of the new ContextMenuItem.
		 * @param url_ String URL To navigate to.
		 * @param separator_ Boolean Whether to use a separator before item.
		 * @param position_ The position to add the item. -1 means add to the end.
		 */
		public static function addNavigationMenuItem( target_:InteractiveObject, label_:String, url_:String = null, separator_:Boolean = false, position_:int = -1 ):void
		{
			if ( !target_.contextMenu )
			{
				target_.contextMenu = new ContextMenu( );
			}

			var item:ContextMenuItem = new ContextMenuItem( label_, separator_,  url_ != null );
			if (  url_ != null )
			{
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
					function ( event_:ContextMenuEvent ):void
					{
						getURL( url_, URLTargets.BLANK );
					}
				);
			}

			if ( position_ < 0 )
			{
				target_.contextMenu.customItems.push( item );
			}
			else
			{
				target_.contextMenu.customItems.splice( position_, 0, item );
			}
		}

		/**
		 * Removes custom context item from ContextMenu of target InteractiveObject.
		 * @param target_ InteractiveObject Target InteractiveObject to modify ContextMenu.
		 * @param position_ The position of the item to remove. -1 means the last.
		 */
		public static function removeMenuItem( target_:InteractiveObject, position_:int = -1 ):void
		{
			if ( position_ < 0 )
			{
				target_.contextMenu.customItems.pop( );
			}
			else
			{
				target_.contextMenu.customItems.splice( position_, 1 );
			}
		}
	}
}
