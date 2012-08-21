
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
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;

	/**
	 * STATIC Class for listing definitions found in SWF files runtime.
	 * Should not be left in production code!
	 * @author Barnabás Bucsy (Lobo)
	 * FIXME: Permissions are not granted from original copyright holder!
	 */
	public class SWFUtil
	{
		/**
		 * Constructor.
		 * @throws Error Static Class.
		 */
		public function SWFUtil( ):void
		{
			throw new Error( 'Tried to instantiate static class!' );
		}

		/**
		 * Return an array of class names in LoaderInfo object.
		 * @param data_ Associated DisplayObject, LoaderInfo object or a ByteArray, which contains swf data.
		 * @param extended_ If false, function returns only classes, else returns all visible definitions (classes, interfaces, functions, namespaces, variables, constants, vectors, etc.).
		 * @param linkedOnly_ If true, function returns only linked classes (objects with linkage), MUCH faster.
		 */
		public static function getDefinitionNames( data_:Object, extended_:Boolean = false, linkedOnly_:Boolean = false ):Array
		{
			var bytes:ByteArray;

			if ( data_ is DisplayObject )
			{
				bytes = ( data_ as DisplayObject ).loaderInfo.bytes;
			}
			else if ( data_ is LoaderInfo )
			{
				bytes = ( data_ as LoaderInfo ).bytes;
			}
			else if ( data_ is ByteArray )
			{
				bytes = data_ as ByteArray;
			}
			else
			{
				throw new Error( 'The specified data is invalid.' );
			}

			var position:uint = bytes.position;
			var finder:Finder = new Finder( bytes );
			bytes.position    = position;
			return finder.getDefinitionNames( extended_, linkedOnly_ );
		}
	}
}

//-----------------------
// INTERNAL FINDER CLASS
//-----------------------
//{

import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.geom.Rectangle;
import flash.system.ApplicationDomain;

internal class Finder
{
    private var _data:SWFByteArray;
    private var _stringTable:Array;
    private var _namespaceTable:Array;
    private var _multinameTable:Array;

	public function Finder( bytes_:ByteArray ):void
	{
		super( );
		_data = new SWFByteArray( bytes_ );
	}

	public function getDefinitionNames( extended_:Boolean, linkedOnly_:Boolean ):Array
	{
		var definitions:Array = [ ];
        var tag:uint;
        var id:uint;
        var length:uint;
        var minorVersion:uint;
        var majorVersion:uint;
        var position:uint;
        var name:String;
        var index:int;

		while ( _data.bytesAvailable )
		{
			tag      = _data.readUnsignedShort( );
			id       = tag >> 6;
			length   = tag & 0x3F;
			length   = ( length == 0x3F ) ? _data.readUnsignedInt( ) : length;
			position = _data.position;

            if ( linkedOnly_ )
			{
				if ( id == 76 )
				{
					var count:uint = _data.readUnsignedShort( );
                    while ( count-- )
					{
						// Object ID
                        _data.readUnsignedShort( );
                        name  = _data.readString( );
                        index = name.lastIndexOf( '.' );
                        if ( index > -1 )
						{
							// Fast. Simple. Cheat ;)
							name = name.substr( 0, index ) + '::' + name.substr( index + 1 );
						}
                        definitions.push(name);
                    }
                }
            }
			else
			{
                switch ( id )
				{
                    case 72:
                    case 82:
                        if ( id == 82 )
						{
                            _data.position += 4;
							// identifier
                            _data.readString( );
                        }

                        minorVersion = _data.readUnsignedShort( );
                        majorVersion = _data.readUnsignedShort( );
                        if ( minorVersion == 0x0010 && majorVersion == 0x002E )
						{
							definitions.push.apply( definitions, getDefinitionNamesInTag( extended_ ) );
						}
						break;
                }
            }

            _data.position = position + length;
        }

        return definitions;
    }

    private function getDefinitionNamesInTag( extended_:Boolean ):Array
	{
        var count:int;
        var kind:uint;
        var id:uint;
        var flags:uint;
        var counter:uint;
        var ns:uint;
        var classesOnly:Boolean = !extended_;
        var names:Array         = [ ];
        _stringTable            = [ ];
        _namespaceTable         = [ ];
        _multinameTable         = [ ];

        // int table
        count = _data.readASInt( ) -1;
        while ( count > 0 && count-- )
		{
            _data.readASInt( );
        }

        // uint table
        count = _data.readASInt( ) -1;
        while ( count > 0 && count-- )
		{
            _data.readASInt( );
        }

        // Double table
        count = _data.readASInt( ) -1;
        while ( count > 0 && count-- )
		{
            _data.readDouble( );
        }

        // String table
        count = _data.readASInt( ) -1;
        id    = 1;
        while ( count > 0 && count-- )
		{
            _stringTable[id] = _data.readUTFBytes( _data.readASInt( ) );
            id++;
        }

        // Namespace table
        count = _data.readASInt( ) -1;
        id    = 1;
        while ( count > 0 && count-- )
		{
            kind = _data.readUnsignedByte( );
            ns   = _data.readASInt();
            if ( kind == 0x16 )
			{
				// only public
				_namespaceTable[ id ] = ns;
			}
            id++;
        }

        // NsSet table
        count = _data.readASInt( ) -1;
        while ( count > 0 && count-- )
		{
             counter = _data.readUnsignedByte( );
             while ( counter-- )
			 {
				 _data.readASInt( );
			 }
        }

        // Multiname table
        count = _data.readASInt( ) -1;
        id    = 1;
        while ( count > 0 && count-- )
		{
            kind = _data.readASInt( );
            switch ( kind )
			{
                case 0x07:
                case 0x0D:
                    ns = _data.readASInt( );
                    _multinameTable[ id ] = [ ns, _data.readASInt( ) ];
					break;

                case 0x0F:
                case 0x10:
                    _multinameTable[id] = [ 0, _stringTable[ _data.readASInt( ) ] ];
					break;

                case 0x11:
                case 0x12:
					break;

                case 0x09:
                case 0x0E:
                    _multinameTable[ id ] = [ 0, _stringTable[ _data.readASInt( ) ] ];
                    _data.readASInt( );
					break;

                case 0x1B:
                case 0x1C:
                    _data.readASInt( );
					break;

                case 0x1D:
					// Generic
                    if ( extended_ )
					{
						// u8 or u30, maybe YOU know?
                        var multinameID:uint = _data.readASInt( );
						// param count (u8 or u30), should always to be 1 in current ABC versions
                        var params:uint = _data.readASInt( );
                        name            = getName(multinameID);

                        while ( params-- )
						{
                            var paramID:uint = _data.readASInt( );

                            if ( name )
							{
								// not the best method, i know
                                name = name + '.<' + getName(paramID) + '>';
                                names.push( name );
                            }
                        }

                        _multinameTable[ id ] = [ 0, name ];
                    }
					else
					{
                        _data.readASInt( );
                        _data.readASInt( );
                        _data.readASInt( );
                    }
					break;
            }

            id++;
        }

        // Method table
        count = _data.readASInt( );
        while ( count > 0 && count-- )
		{
            var paramsCount:int = _data.readASInt();
            counter             = paramsCount;
            _data.readASInt( );
            while ( counter-- )
			{
				_data.readASInt();
			}
            _data.readASInt( );
            flags = _data.readUnsignedByte( );

            if ( flags & 0x08 )
			{
                counter = _data.readASInt( );
                while ( counter-- )
				{
                    _data.readASInt( );
                    _data.readASInt( );
                }
            }

            if ( flags & 0x80 )
			{
                counter = paramsCount;
                while ( counter-- )
				{
					_data.readASInt( );
				}
            }
        }

        // Metadata table
        count = _data.readASInt( );
        while ( count > 0 && count-- )
		{
            _data.readASInt( );

            counter = _data.readASInt( );
            while ( counter-- )
			{
                _data.readASInt( );
                _data.readASInt( );
            }
        }

        // Instance table
        count               = _data.readASInt( );
        var classCount:uint = count;
        var name:String;
        var isInterface:Boolean;
        while ( count > 0 && count-- )
		{
            id = _data.readASInt( );
            _data.readASInt( );
            flags = _data.readUnsignedByte( );
            if ( flags & 0x08 )
			{
				ns = _data.readASInt( );
			}
            isInterface = Boolean( flags & 0x04 );
            counter     = _data.readASInt( );
            while ( counter-- )
			{
				_data.readASInt();
			}
			// iinit
            _data.readASInt( );
            readTraits( );

            if ( classesOnly && !isInterface )
			{
                name = getName( id );
                if ( name )
				{
					names.push( name );
				}
            }
        }

        if ( classesOnly )
		{
			return names;
		}

        // Class table
        count = classCount;
        while ( count && count-- )
		{
			// cinit
            _data.readASInt( );
            readTraits( );
        }

        // Script table
        count = _data.readASInt( );
        var traits:Array;
        while ( count && count-- )
		{
			// init
            _data.readASInt( );
            traits = readTraits( true );
            if ( traits.length )
			{
				names.push.apply( names, traits );
			}
        }

        return names;
    }

    private function readTraits( buildNames_:Boolean = false ):Array
	{
        var kind:uint;
        var counter:uint;
        var ns:uint;
        var id:uint;
        var name:String;
        var traitCount:uint = _data.readASInt( );
        var names:Array;
        if ( buildNames_ )
		{
			names = [ ];
		}

        while ( traitCount-- )
		{
			// name
            id                 = _data.readASInt( );
            kind               = _data.readUnsignedByte( );
            var upperBits:uint = kind >> 4;
            var lowerBits:uint = kind & 0xF;
            _data.readASInt( );
            _data.readASInt( );

            switch ( lowerBits )
			{
                case 0x00:
                case 0x06:
                    if ( _data.readASInt( ) )
					{
						_data.readASInt( );
					}
                    break;
            }

            if ( buildNames_ )
			{
                name = getName( id );
                if ( name )
				{
					names.push( name );
				}
            }

            if ( upperBits & 0x04 )
			{
                counter = _data.readASInt( );
                while ( counter-- )
				{
					_data.readASInt( );
				}
            }
        }

        return names;
    }

    private function getName( id:uint ):String
	{
        if ( !( id in _multinameTable ) )
		{
			return null;
		}
        var mn:Array = _multinameTable[ id ] as Array;
        var ns:uint  = mn[ 0 ] as uint;
        var nsName:String = _stringTable[ _namespaceTable[ ns ] as uint ] as String;
        var name:String = mn[ 1 ] is String ? mn[ 1 ] : ( _stringTable[ mn[ 1 ] as uint ] as String );
        if ( nsName && nsName.indexOf( '__AS3__' ) < 0 /* cheat! */)
		{
			name = nsName + '::' + name;
		}
        return name;
    }
}

//}
//-----------------------------
// INTERNAL SWFBYTEARRAY CLASS
//-----------------------------
//{

internal class SWFByteArray extends ByteArray
{
    private static const TAG_SWF:String            = 'FWS';
    private static const TAG_SWF_COMPRESSED:String = 'CWS';

    private var _bitIndex:uint;
    private var _version:uint;
    private var _frameRate:Number;
    private var _rect:Rectangle;

    public function SWFByteArray( data:ByteArray = null ):void
	{
        super( );
        super.endian = Endian.LITTLE_ENDIAN;
        var endian:String;
        var tag:String;
        if ( data )
		{
            endian      = data.endian;
            data.endian = Endian.LITTLE_ENDIAN;

            if ( data.bytesAvailable > 26 )
			{
                tag = data.readUTFBytes( 3 );

                if ( tag == SWFByteArray.TAG_SWF || tag == SWFByteArray.TAG_SWF_COMPRESSED )
				{
                    _version = data.readUnsignedByte( );
                    data.readUnsignedInt( );
                    data.readBytes( this );
                    if ( tag == SWFByteArray.TAG_SWF_COMPRESSED )
					{
						super.uncompress( );
					}
                }
				else
				{
					throw new ArgumentError( 'Loaded file is an unknown type.' );
				}

                readHeader( );
            }

            data.endian = endian;
        }
    }

    public function writeBytesFromString( bytesHexString:String ):void
	{
        var length:uint = bytesHexString.length;
        for ( var i:uint = 0; i < length; i += 2 )
		{
            var hexByte:String = bytesHexString.substr( i, 2 );
            var byte:uint      = parseInt( hexByte, 16 );
            writeByte( byte );
        }
    }

    public function readRect( ):Rectangle
	{
        var pos:uint    = super.position;
        var byte:uint   = this[ pos ];
        var bits:uint   = byte >> 3;
        var xMin:Number = readBits( bits, 5 ) *0.05;
        var xMax:Number = readBits( bits ) *0.05;
        var yMin:Number = readBits( bits ) *0.05;
        var yMax:Number = readBits( bits ) *0.05;
        super.position  = pos + Math.ceil( ( bits *4 -3 ) /8 ) +1;
        return new Rectangle( xMin, yMin, xMax - xMin, yMax - yMin );
    }

    public function readBits( length:uint, start:int = -1 ):Number
	{
        if ( start < 0 )
		{
			start = _bitIndex;
		}
        _bitIndex                    = start;
        var byte:uint                = this[super.position];
        var out:Number               = 0;
        var shift:Number             = 0;
        var currentByteBitsLeft:uint = 8 - start;
        var bitsLeft:Number          = length - currentByteBitsLeft;

        if ( bitsLeft > 0 )
		{
            super.position++;
            out = readBits( bitsLeft, 0 ) | ( ( byte & ( ( 1 << currentByteBitsLeft ) - 1 ) ) << bitsLeft );
        }
		else
		{
            out       = ( byte >> ( 8 - length - start ) ) & ( ( 1 << length ) -1 );
            _bitIndex = ( start + length ) %8;
            if ( start + length > 7 )
			{
				super.position++;
			}
        }

        return out;
    }

    public function readASInt( ):int
	{
        var result:uint = 0;
        var i:uint      = 0;
		var byte:uint;
        do
		{
            byte    = super.readUnsignedByte();
            result |= ( byte & 0x7F ) << ( i *7 );
            i++;
        }
		while ( byte & 1 << 7 );
        return result;
    }

    public function readString( ):String
	{
        var i:uint = super.position;
        while ( this[ i ] && i++ )
		{
			//
		}
        var str:String = super.readUTFBytes( i - super.position );
        super.position = i +1;
        return str;
    }

	// for debug
    public function traceArray( array:ByteArray ):String
	{
        var out:String = '';
        var pos:uint   = array.position;
        var i:uint     = 0;
        array.position = 0;

        while ( array.bytesAvailable )
		{
            var str:String  = array.readUnsignedByte( ).toString( 16 ).toUpperCase( );
            str             = str.length < 2 ? '0' + str : str;
            out            += str + ' ';
        }

        array.position = pos;
        return out;
    }

    private function readFrameRate( ):void
	{
        if ( _version < 8 )
		{
            _frameRate = super.readUnsignedShort( );
        }
		else
		{
            var fixed:Number = super.readUnsignedByte( ) / 0xFF;
            _frameRate       = super.readUnsignedByte( ) + fixed;
        }
    }

    private function readHeader( ):void
	{
        _rect = readRect( );
        readFrameRate( );
		// num of frames
        super.readShort( );
    }

    public function get version( ):uint
	{
        return _version;
    }

    public function get frameRate( ):Number
	{
        return _frameRate;
    }

    public function get rect( ):Rectangle
	{
        return _rect;
    }
}

//}

/**
 * ---------------------------------------------------------------------------------
 *  ORIGINAL CODE LICENSE
 * ---------------------------------------------------------------------------------
 *
 * getDefinitionNames by Denis Kolyako. August 13, 2008. Updated March 9, 2010.
 * Visit http://etcs.ru for documentation, updates and more free code.
 * You may distribute this class freely, provided it is not modified in any way (including
 * removing this header or changing the package path).
 * Please contact etc[at]mail.ru prior to distributing modified versions of this class.
 */
