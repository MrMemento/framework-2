
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
package com.memento.core.net.loaders
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * Wrapper Class for URLLoader Class to remember loaded request.
	 * @see com.memento.data.converters.Base64Converter
	 * @author Barnabás Bucsy (Lobo)
	 */
	public class ExtendedURLLoader extends URLLoader
	{
		private var _request:URLRequest;
		private var _id:String;

		/**
		 * Constructor
		 */
		public function ExtendedURLLoader( id_:String = '', request_:URLRequest = null ):void
		{
			_id      = id_;
			_request = request_;
			super( request_ );
		}

		/**
		 * Starts loading resource.
		 * @param request_ URLRequest URLRequest to load
		 */
		override public function load( request_:URLRequest ):void
		{
			_request = request_;
			super.load( request_ );
		}

		/**
		 * Closes current URLLoader.
		 */
		override public function close( ):void
		{
			_request = null;
			super.close( );
		}

		/**
		 * Returns the URLRequest being loaded.
		 * @return URLRequest The URLRequest being loaded.
		 */
		public function get request( ):URLRequest
		{
			return _request;
		}

		/**
		 * Returns the ID of ExtendedURLRequest instance.
		 * @return String The ID of ExtendedURLRequest instance.
		 */
		public function get id( ):String
		{
			return _id;
		}
	}
}
