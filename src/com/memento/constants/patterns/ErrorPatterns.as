
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
package com.memento.constants.patterns
{
	/**
	 * STATIC Class, contains common replace patterns used when working with Errors.
	 * @author Barnabás Bucsy (Lobo)
	 * @private
	 * TODO: Check on namespaces using "::"!
	 */
	public class ErrorPatterns
	{
		/**
		 * Pattern for splitting stack traces.
		 */
		public static const STACK_SEPARATOR:String = '\n\tat ';

		/**
		 * Pattern for general Error separating.
		 */
		public static const ERROR_SEPARATOR:String = '^[^:]*';

		/**
		 * Pattern for finding Error class names.
		 */
		public static const ERROR_CLASS:String = '^[^$\\/]*';

		/**
		 * Pattern for finding Error function names.
		 */
		public static const ERROR_FUNCTION:String = '\\$?\\/.*';

		/**
		 * Pattern for static function start.
		 */
		public static const ERROR_STATIC_PREFIX:String = '$';

		/**
		 * Pattern for finding Error function prefix.
		 */
		public static const ERROR_FUNCTION_PREFIX:String = '/';

		/**
		 * Pattern for general Error separating.
		 */
		public static const ERROR_LINE_SEPARATOR:String = ':';

		/**
		 * Pattern for finding Error message.
		 */
		public static const ERROR_MESSAGE:String = '(?<=:).*$';

		/**
		 * Pattern for finding Error debugger info.
		 */
		public static const ERROR_FILE_INFO:String = '(?<=\\[)[^\\]]*';

		/**
		 * Pattern for finding Error debugger file.
		 */
		public static const ERROR_FILE_AND_LINE:String = '(?<=[\\\\\\/])[^\\\\\\/]*$';

		/**
		 * Pattern for finding Error message.
		 */
		public static const ERROR_CLASS_AND_FUNCTION:String = '(?<=::)[^\\(]*';

		/**
		 * Constructor
		 * @throws Error Static Class.
		 */
		public function ErrorPatterns( ):void
		{
			throw new Error( 'Tried to instantiate static class!' );
		}
	}
}
