<?php

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

/**
 * Class for bypassing Flash Player Security Context limitations.
 */
class FlashProxy
{
	public static $CURL     = 'curl';
	public static $READFILE = 'readfile';

	private $_request;
	private $_extension;
	private $_ignore = Array(
		'url'
	);

	function __construct( $mode_ = self::READFILE )
	{
		$this->_request = base64_decode( $_REQUEST[ 'url' ] );
		$this->_extension  = pathinfo( $this->requestURL );

		if ( $mode_ == self::READFILE )
		{
			$this->readFile( );
		}
		else
		{
			$this->readCurl( );
		}
	}

	function addHeader( )
	{
		switch ( $this->_extension )
		{
			case 'jpg':
			case 'jpeg':

				header( 'Content-Type: image/jpeg' );
				break;

			case 'gif':

				header( 'Content-Type: image/gif' );
				break;

			case 'png':

				header( 'Content-Type: image/png' );
				break;

			default:

				header( 'Content-Type: text/xml' );
				break;
		}

	function readFile( )
	{
		$this->addHeader( );

	    ob_clean( );
	    flush( );
		readfile( $this->_request );
	}

	function readCurl( )
	{
		$post = Array( );
		foreach( $_POST as $key => $value )
		{
			if ( !in_array( $key, $this->_ignore ) )
			{
				$post[ ] = $key . '=' . $value;
			}
		}

		$session = curl_init( $this->_request );

		if ( count( $post ) > 0 )
		{
			curl_setopt( $session, CURLOPT_POST,       true );
			curl_setopt( $session, CURLOPT_POSTFIELDS, implode( "&", $post ) );
		}
		curl_setopt( $session, CURLOPT_HEADER,         false );
		curl_setopt( $session, CURLOPT_FOLLOWLOCATION, true );
		curl_setopt( $session, CURLOPT_RETURNTRANSFER, true );
		curl_setopt( $session, CURLOPT_TIMEOUT,        10 );

		$content = curl_exec( $session );

		if ( curl_errno( $session ) )
		{
		    print curl_error( $session );
			curl_close( $session );
			return;
		}

		curl_close( $session );

		$this->addHeader( );
		print $content;
	}
}

new FlashProxy( FlashProxy::$CURL );
