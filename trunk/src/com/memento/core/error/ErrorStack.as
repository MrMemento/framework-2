
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
	import com.memento.constants.patterns.ErrorPatterns;
	import com.memento.core.regexp.RegExpUser;
	import com.memento.utils.ErrorUtil;
	import com.memento.utils.StringUtil;
	import com.memento.utils.ClassUtil;
//	import com.memento.utils.ObjectUtil;

	/**
	 * Class for managing Error objects' stackTraces in ActionScript.
	 * @author Barnabás Bucsy (Lobo)
	 */
	public class ErrorStack extends RegExpUser
	{
		/**
		 * Constant for constructor function.
		 */
		public static const CONSTRUCTOR:String = '[constructor]';

		/**
		 * Constant for no data.
		 */
		public static const NO_DATA:String = '[no data]';

		/**
		 * Static function prefix.
		 */
		public static const STATIC_PREFIX:String = '[static]::';

		/**
		 * File name prefix.
		 */
		public static const FILE_PREFIX:String = '[file]: "';

		/**
		 * Line number prefix.
		 */
		public static const LINE_PREFIX:String   = '" at [line]: ';

		/**
		 * Class name of Error.
		 */
		private var _errorClass:String;

		/**
		 * Message of Error.
		 */
		private var _errorMessage:String;

		/**
		 * Array of StackItems, if available.
		 */
		private var _stack:Array;

		/**
		 * Constructor
		 * @param error_ Error The Error to parse.
		 * @param excludePattern_ RegExp Pattern to check stack chunks against.
		 */
		public function ErrorStack( error_:Error, excludePattern_:RegExp = null ):void
		{
			_errorClass   = error_.name;
			_errorMessage = error_.message;

			var stackStr:String = error_.getStackTrace( );
			if ( stackStr != null )
			{
				_stack = [ ];
				fetchCollector( );

				var stackChunks:Array = stackStr.split( ErrorPatterns.STACK_SEPARATOR );
				stackChunks.shift( );

				var separatorRegExp:RegExp     = __collector.get( ErrorPatterns.ERROR_SEPARATOR );
				var classFunctionRegExp:RegExp = __collector.get( ErrorPatterns.ERROR_CLASS_AND_FUNCTION );
				var classRegExp:RegExp         = __collector.get( ErrorPatterns.ERROR_CLASS );
				var functionRegExp:RegExp      = __collector.get( ErrorPatterns.ERROR_FUNCTION );
				var fileInfoRegExp:RegExp      = __collector.get( ErrorPatterns.ERROR_FILE_INFO );
				var fileAndLineRegExp:RegExp   = __collector.get( ErrorPatterns.ERROR_FILE_AND_LINE );
				var j:uint                     = stackChunks.length;
				var match:Object;
				var func:String;
				var tmpStack:Object;
				var classAndFunction:String;
				for ( var i:uint = 1; i < j; i++ )
				{
					if ( excludePattern_ != null && excludePattern_.test( stackChunks[ i ] ) )
					{
						continue;
					}

					tmpStack               = new StackItem( );
					tmpStack.packageString = stackChunks[ i ].match( separatorRegExp )[ 0 ];
					classAndFunction       = stackChunks[ i ].match( classFunctionRegExp )[ 0 ];
					tmpStack.className     = classAndFunction.match( classRegExp )[ 0 ];
					match                  = classAndFunction.match( functionRegExp );
					if ( match != null )
					{
						tmpStack.functionName = match[ 0 ].replace( ErrorPatterns.ERROR_STATIC_PREFIX, STATIC_PREFIX ).replace( ErrorPatterns.ERROR_FUNCTION_PREFIX, StringUtil.EMPTY );
					}
					else
					{
						tmpStack.functionName = CONSTRUCTOR;
					}

					match = stackChunks[ i ].match( fileInfoRegExp );
					if ( match != null )
					{
						tmpStack.debugInfo = FILE_PREFIX + match[ 0 ].match( fileAndLineRegExp )[ 0 ].replace( ErrorPatterns.ERROR_LINE_SEPARATOR, LINE_PREFIX );
					}
					else
					{
						tmpStack.debugInfo = NO_DATA;
					}

					_stack.push( tmpStack );
				}
			}
		}

		/**
		 * Whether stack trace is available.
		 * @return Boolean Whether stack trace is available.
		 */
		public function get stackAvailable( ):Boolean
		{
			return _stack != null;
		}

		/**
		 * Getter function for Array of StackItems, if available.
		 * @return Array Array of StackItems, if available.
		 */
		public function get stackArray( ):Array
		{
			return /*ObjectUtil.clone(*/ _stack /*)*/;
		}

		/**
		 * Getter function for Class name of Error.
		 * @return String Class name of Error.
		 */
		public function get errorClass( ):String
		{
			return _errorClass;
		}

		/**
		 * Getter function for message of Error.
		 * @return String Message of Error.
		 */
		public function get errorMessage( ):String
		{
			return _errorMessage;
		}
		}

		/**
		 * toString function.
		 * @return String
		 */
		public function toString( ):String
		{
			return '[ErrorStack ' + _errorClass + ']' + ( _errorMessage != null && _errorMessage != StringUtil.EMPTY ? ': ' + _errorMessage : StringUtil.EMPTY );
		}
	}
}
