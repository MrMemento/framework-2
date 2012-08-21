
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
package com.memento.utils
{
	import flash.utils.ByteArray;
	/**
	 * STATIC Class for working with Objects in ActionScript.
	 * @author Barnabás Bucsy (Lobo)
	 */
	public class ObjectUtil
	{
		/**
		 * Constructor
		 * @throws Error Static Class.
		 */
		public function ObjectUtil( ):void
		{
			throw new Error( 'Tried to instantiate static class!' );
		}

		/**
		 * Clones an Object based on ByteArray.writeObject().
		 * @param source_ Object The Object to clone.
		 * @return Object The cloned Object.
		 */
		public static function clone( source_:* ):*
		{
			var ba:ByteArray = new ByteArray( );
			ba.writeObject( source_ );
			ba.position = 0;
			return ba.readObject( );
		}

		/**
		 * Synchronizez two Object's properties.
		 * @param target_ Object The Object to modify.
		 * @param reference_ Object The reference Object.
		 * @param nullDeletedItems_ Boolean Wether to null out items to be deleted. Default is true.
		 */
		public static function synchronize( target_:Object, reference_:Object, nullDeletedItems_:Boolean = true ):void
		{
			for ( var label:String in target_ )
			{
				if ( nullDeletedItems_ )
				{
					if ( !label in reference_ )
					{
						target_[ label ] = null;
						delete target_[ label ];
					}
				}
				else
				{
					if ( !label in reference_ )
					{
						delete target_[ label ];
					}
				}
			}

			for ( label in reference_ )
			{
				target_[ label ] = reference_[ label ];
			}
		}

		/**
		 * Clears all properties of an Object.
		 * @param target_ Object The Object to clear.
		 * @param nullDeletedItems_ Boolean Wether to null out items to be deleted. Default is true.
		 */
		public static function clear( target_:Object, nullDeletedItems_:Boolean = true ):void
		{
			var label:String;
			if ( nullDeletedItems_ )
			{
				for ( label in target_ )
				{
					target_[ label ] = null;
					delete target_[ label ];
				}
			}
			else
			{
				for ( label in target_ )
				{
					delete target_[ label ];
				}
			}
		}
	}
}
