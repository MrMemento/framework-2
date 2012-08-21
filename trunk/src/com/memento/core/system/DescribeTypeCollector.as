
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
	import flash.utils.describeType;

	import com.memento.utils.ClassUtil;
	import com.memento.utils.ObjectUtil;
	import com.memento.core.system.GarbageCollector;

	/**
	 * STATIC Class for collecting describeType call results.
	 * @author Barnabás Bucsy (Lobo)
	 */
	public final class DescribeTypeCollector
	{
		/**
		 * Object for collecting describeType call results.
		 */
		private static var __instances:Object = { };

		/**
		 * Flag for storing GarbageCollector registered status.
		 */
		private static var __registered:Boolean = false;

		/**
		 * Constructor
		 * @throws Error Static Class.
		 */
		public function DescribeTypeCollector( ):void
		{
			throw new Error( 'Tried to instantiate static class!' );
		}

		/**
		 * Static function for getting Class descriptions.
		 * @param Class_ Class Class to get description of.
		 * @return XML The describeType result.
		 */
		public static function get( Class_:Class ):XML
		{
			var ref:String = ClassUtil.getClassName( Class_ );
			if ( !__instances[ ref ] )
			{
				__instances[ ref ] = describeType( Class_ );
			}

			if ( !__registered )
			{
				GarbageCollector.register( DescribeTypeCollector );
				__registered = true;
			}

			return __instances[ ref ] as XML;
		}

		/**
		 * Clears all cached Class descriptions.
		 */
		public static function dispose( ):void
		{
			ObjectUtil.clear( __instances );

			if ( __registered )
			{
				GarbageCollector.unregister( DescribeTypeCollector );
				__registered = false;
			}
		}
	}
}
