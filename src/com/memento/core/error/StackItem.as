
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
package com.memento.core.error
{
	/**
	 * Class for storing Error objects' stackTrace items.
	 * @author Barnabás Bucsy (Lobo)
	 */
	public class StackItem
	{
		/**
		 * Package of Class where the error occured if available.
		 * Default is null.
		 */
		private var _packageString:String;

		/**
		 * Class where the error occured if available.
		 * Default is null.
		 */
		private var _className:String;

		/**
		 * Function where the error occured if available.
		 * Default is null.
		 */
		private var _functionName:String;

		/**
		 * Debug info if available (line, character).
		 * Default is null.
		 */
		private var _debugInfo:String;

		/**
		 * Constructor
		 * @param packageString String Package. Default is null;
		 * @param className String Class. Default is null;
		 * @param functionName String Function. Default is null;
		 * @param debugInfo String Debug info. Default is null;
		 */
		public function StackItem(
			packageString_:String = null,
			className_:String     = null,
			functionName_:String  = null,
			debugInfo_:String     = null
		):void
		{
			_packageString = packageString_;
			_className     = className_;
			_functionName  = functionName_;
			_debugInfo     = debugInfo_;
		}

		/**
		 * toString() function
		 * @return String
		 */
		public function toString( ):String
		{
			if ( packageString != null )
			{
				return '[StackItem ' +
					_packageString + '::' + _className + '::' + _functionName +
					( _debugInfo ? ' ' + _debugInfo : ''  ) +
					']';
			}
			else
			{
				return '[StackItem - data not available]';
			}
		}

		/**
		 * Getter function for the Package of Class where the error occured if available.
		 * @return String Package of Class where the error occured if available.
		 * @default String null.
		 */
		public function get packageString( ):String
		{
			return _packageString;
		}

		/**
		 * Getter function for the Class where the error occured if available.
		 * @return String Class where the error occured if available.
		 * @default String null.
		 */
		public function get className( ):String
		{
			return _className;
		}

		/**
		 * Getter function for the Function where the error occured if available.
		 * @return String Function where the error occured if available.
		 * @default String null.
		 */
		public function get functionName( ):String
		{
			return _functionName;
		}

		/**
		 * Getter function for debug info if available (line, character).
		 * @return String Debug info if available (line, character).
		 * @default String null.
		 */
		public function get debugInfo( ):String
		{
			return _debugInfo;
		}
	}
}
