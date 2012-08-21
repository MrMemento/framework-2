﻿/** * Copyright 2011 by Barnabás Bucsy * * This file is part of The Memento Framework. * * The Memento Framework is free software: you can redistribute it * and/or modify it under the terms of the GNU Lesser General Public * License as published by the Free Software Foundation, either * version 3 of the License, or (at your option) any later version. * * The Memento Framework is distributed in the hope that it will be * useful, but WITHOUT ANY WARRANTY; without even the implied warranty * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU * Lesser General Public License for more details. * * You should have received a copy of the GNU Lesser General Public * License along with The Memento Framework. If not, see * <http://www.gnu.org/licenses/>. */package com.memento.utils{	import com.memento.core.singleton.SingletonCollector;	import com.memento.core.regexp.PatternFormatter;	import com.memento.core.regexp.StaticRegExpUser;	import com.memento.constants.patterns.MathPatterns;	import com.memento.constants.patterns.TypographyPatterns;	import com.memento.constants.patterns.ReplacePatterns;	/**	 * STATIC Class for managing Strings in ActionScript.	 * @author Barnabás Bucsy (Lobo)	 */	public class StringUtil extends StaticRegExpUser	{		/**		 * Constant for empty String.		 */		public static const EMPTY:String = '';		/**		 * Constant for space character.		 */		public static const SPACE:String = ' ';		/**		 * Constant for end of line.		 */		public static const EOL:String = '\n';		/**		 * Array of capitalization exception words. These words		 * will not be capitalized using all words capitalization.		 */		public static var CAPITALIZE_EXCEPTIONS:Array = [			'a', 'an', 'and', 'at',			'but',			'for', 'from',			'in',			'of', 'on', 'or', 'out',			'the', 'to',			'with'		];		/**		 * Flag for using exceptions when capitalizing.		 */		private static var __useExceptions:Boolean;		/**		 * Flag for using only ASCII characters when capitalizing.		 */		private static var __useASCII:Boolean;		//-------------		// CONSTRUCTOR		//-------------		/**		 * Constructor		 * @throws Error Static Class.		 */		public function StringUtil( ):void		{			throw new Error( 'Tried to instantiate static class!' );		}		//--------------------		// FORMAT RECOGNITION		//--------------------		/**		 * Tests if a String is empty.		 * @param string_ String The String to examine.		 * @return Boolean True if the String is empty or null.		 */		public static function isEmpty( string_:String ):Boolean		{			return string_ == null || string_ == EMPTY;		}		/**		 * Tests if a string is made up of only one character.		 * @param string_ String The String to examine.		 * @return Boolean True if the String is made up of only one character.		 */		public static function isCharacter( string_:String ):Boolean		{			if ( string_ == null )			{				return false;			}			return string_.length == 1;		}		/**		 * Tests a String against the numeric pattern.		 * @param string_ String The String to examine.		 * @return Boolean True if the String matches the pattern.		 */		public static function isNumeric( string_:String ):Boolean		{			if ( string_ == null )			{				return false;			}			fetchCollector( );			return __collector.get( PatternFormatter.only( MathPatterns.NUMBER ) ).test( string_ );		}		/**		 * Returns if String is representation of Boolean true.		 * @param String The String to examin.		 * @return Boolean If the string is representation of true.		 */		public static function toBoolean( string_:String ):Boolean		{			if ( string_ == '1' || string_ == 'true' )			{				return true;			}			return false;		}		//----------		// TRIMMING		//----------		/**		 * Removes starting whitespaces from a String.		 * @param string_ String The String to modify.		 * @return The modified String.		 */		public static function trimLeft( string_:String ):String		{			fetchCollector( );			return string_.replace( __collector.get( PatternFormatter.starts( TypographyPatterns.SPACES ) ), EMPTY );		}		/**		 * Removes ending whitespaces from a String.		 * @param string_ String The String to modify.		 * @return The modified String.		 */		public static function trimRight( string_:String ):String		{			fetchCollector( );			return string_.replace( __collector.get( PatternFormatter.ends( TypographyPatterns.SPACES ) ), EMPTY );		}		/**		 * Removes starting and ending whitespaces from a String.		 * @param string_ String The String to modify.		 * @return The modified String.		 */		public static function trim( string_:String ):String		{			fetchCollector( );			return string_.replace( __collector.get(				PatternFormatter.starts( TypographyPatterns.SPACES ) + PatternFormatter.OR + PatternFormatter.ends( TypographyPatterns.SPACES ),				true			), EMPTY );		}		/**		 * Removes starting new lines from a String.		 * @param string_ String The String to modify.		 * @return The modified String.		 */		public static function trimLinesLeft( string_:String ):String		{			fetchCollector( );			return string_.replace( __collector.get(				PatternFormatter.starts( TypographyPatterns.NEW_LINES )			), EMPTY );		}		/**		 * Removes ending new lines from a String.		 * @param string_ String The String to modify.		 * @return The modified String.		 */		public static function trimLinesRight( string_:String ):String		{			fetchCollector( );			return string_.replace( __collector.get(				PatternFormatter.ends( TypographyPatterns.NEW_LINES )			), EMPTY );		}		/**		 * Removes starting and ending new lines from a String.		 * @param string_ String The String to modify.		 * @return The modified String.		 */		public static function trimLines( string_:String ):String		{			fetchCollector( );			return string_.replace( __collector.get(				PatternFormatter.starts( TypographyPatterns.NEW_LINES ) +				PatternFormatter.OR                                     +				PatternFormatter.ends( TypographyPatterns.NEW_LINES ),				true			), EMPTY );		}		//-----------		// STRIPPING		//-----------		/**		 * Strips line breaks from a String. Replaces them with single space		 * character.		 * @param string_ String The String to strip.		 * @return The stripped String.		 */		public static function stripLineBreaks( string_:String ):String		{			fetchCollector( );			string_ = trimLines( string_ );			return string_.replace( __collector.get(				TypographyPatterns.SPACES_OR_NEW_LINES,				true			), SPACE );		}		/**		 * Limits following line break count in a String.		 * @param string_ String The String to modify.		 * @param count_ Maximum appearence of following line breaks.		 * @return String The modified String.		 */		public static function limitLineBreakCount( string_:String, count_:uint = 2 ):String		{			fetchCollector( );			// do not store this expression in collector			var re:RegExp = new RegExp(				TypographyPatterns.NUMEROUS_EOL.replace(					__collector.get( ReplacePatterns.DECIMAL, true ),					count_				), 'gi'			);			return string_.replace( re, repeat( EOL, count_ ) );		}		//---------		// PADDING		//---------		/**		 * Pad a String with specified character from left to desired length.		 * @param string_ String The String to pad.		 * @param character_ String The character to pad with.		 * @param length_ uint Desired length of padded String.		 * @return String The padded String.		 * @throws Error Throws Error if character_ is longer than one character.		 * @throws Error Throws Error if string_'s length is bigger than length_.		 */		public static function padLeft( string_:String, character_:String, length_:uint ):String		{			testPad( string_, character_, length_ );			while ( string_.length < length_ )			{				string_ = character_ + string_;			}			return string_;		}		/**		 * Pad a String with specified character from left to desired length.		 * @param string_ String The String to pad.		 * @param character_ String The character to pad with.		 * @param length_ uint Desired length of padded String.		 * @return String The padded String.		 * @throws Error Throws Error if character_ is longer than one character.		 * @throws Error Throws Error if string_'s length is bigger than length_.		 */		public static function padRight( string_:String, character_:String, length_:uint ):String		{			testPad( string_, character_, length_ );			while ( string_.length < length_ )			{				string_ += character_;			}			return string_;		}		/**		 * Private function for testing padding parameters.		 * @param string_ String The String to pad.		 * @param character_ String The character to pad with.		 * @param length_ uint Desired length of padded String.		 * @throws Error Throws Error if character_ is longer than one character.		 * @throws Error Throws Error if string_'s length is bigger than length_.		 */		private static function testPad( string_:String, character_:String, length_:uint ):void		{			if ( !isCharacter( character_) )			{				throw new Error( 'Pad character must be one character long!' );			}			if ( string_.length > length_ )			{				throw new Error( 'String is longer than desired length!' );			}		}		/**		 * Repeats a character sequence until desired length is reached.		 * @param string_ String The character sequence to repeat.		 * @param length_ uint Desired length of output.		 * @return String A String that is length_ long filled with given string_ pattern.		 */		public static function repeat( string_:String, length_:uint ):String		{			var s:String = string_;			while ( s.length < length_ )			{				s += string_;			}			return s.substr( 0, length_ );		}		//----------		// WRAPPING		//----------		/**		 * Function for wrapping a text based on character number. Practical to		 * be used with fixed width fonts. Expects no HTML formatting.		 * @param string_ String The text to wrap.		 * @param length_ uint Desired line length.		 * @return String The wrapped text.		 */		public static function wordWrap( string_:String, length_:uint ):String		{			fetchCollector( );			var endsWithNewLine:Boolean = __collector.get(				PatternFormatter.ends( TypographyPatterns.NEW_LINE )			).test( string_ );			// do not store this expression in collector			var re:RegExp = new RegExp(				TypographyPatterns.WORD_WRAP.replace(					__collector.get( ReplacePatterns.DECIMAL, true ),					length_				), 'gim'			);			string_ = string_.replace( re, '$1$2' + EOL );			return endsWithNewLine ? string_ : string_.substr( 0, string_.length -1 );		}		/**		 * Function for wrapping a text based on character number. After new line		 * character all lines will be indented with presented indent_ String.		 * Practical to be used with fixed width fonts. Expects no HTML formatting.		 * @param string_ String The text to wrap.		 * @param length_ Desired line length.		 * @param indent_ String The indentation String.		 * @return String The wrapped text.		 * @throws Error Throws Error if indent_'s length is bigger than length_.		 */		public static function indentedWordWrap( string_:String, length_:uint, indent_:String = '    ' ):String		{			if ( indent_.length >= length_ )			{				throw new Error( 'Indentation\'s length is bigger than column\'s length!' );			}			fetchCollector( );			var endsWithNewLine:Boolean = __collector.get(				PatternFormatter.ends( TypographyPatterns.NEW_LINE )			).test( string_ );			// do not store this expression in collector			var re:RegExp = new RegExp(				TypographyPatterns.WORD_WRAP.replace(					__collector.get( ReplacePatterns.DECIMAL, true ),					length_				), 'im'			);			var firstLine:String = string_.match( re )[ 0 ];			if ( string_.length == firstLine.length )			{				return string_;			}			string_ = string_.substr( firstLine.length );			// do not store this expression in collector			re = new RegExp(				TypographyPatterns.WORD_WRAP.replace(					__collector.get( ReplacePatterns.DECIMAL, true ),					length_ - indent_.length				), 'gim'			);			string_ = trimLines( firstLine ) + EOL + string_.replace( re, indent_ + '$1$2' + EOL );			return endsWithNewLine ? string_ : string_.substr( 0, string_.length -1 );		}		//--------------		// CAPITALIZING		//--------------		/**		 * Function for capitalizing words in a String. When all_ is set to true,		 * exceptions will occur based on CAPITALIZE_EXCEPTIONS Array.		 * @param string_ String The String to capitalize.		 * @param all_ Boolean Whether to capitalize all words in the String.		 * @param exceptions_ Boolean Can explicitly disable exceptions.		 * @param useASCII_ Boolean If set to true, Regexp will work with \w character sequences.		 * @return String The capitalized String.		 */		public static function capitalizeWords(			string_:String,			all_:Boolean        = false,			exceptions_:Boolean = true,			useASCII_:Boolean   = false		):String		{			if ( string_ == null )			{				return '';			}			fetchCollector( );			__useASCII      = useASCII_;			__useExceptions = exceptions_;			// capitalize first word regardless exceptions			string_ = string_.replace( __collector.get(				__useASCII ? TypographyPatterns.FIRST_WORD_CHAR : TypographyPatterns.FIRST_CHAR			), capitalize );			if ( all_ )			{				string_ = string_.replace( __collector.get(					__useASCII ? TypographyPatterns.WORD_CHARS : TypographyPatterns.WORDS,					true				), capitalizeFirstCharacter );			}			return string_;		}		/**		 * Function for capitalizing first character in a sequence of		 * whitespaces and a word, if allowed by CAPITALIZE_EXCEPTIONS.		 * @param string_ String The String to capitalize.		 * @param ...args_ Array Rest parameter for sub-matches.		 * @return String The capitalized String.		 */		private static function capitalizeFirstCharacter( string_:String, ...args_:Array ):String		{			if ( __useExceptions && CAPITALIZE_EXCEPTIONS.indexOf( trim( string_ ) ) != -1 )			{				return string_;			}			return string_.replace( __collector.get(				__useASCII ? TypographyPatterns.FIRST_WORD_CHAR : TypographyPatterns.FIRST_CHAR			), capitalize );		}		/**		 * Function for capitalizing a sequence of characters to be		 * used with String.replace() function.		 * @param string_ String The String to capitalize.		 * @param ...args_ Array Rest parameter for sub-matches.		 * @return String The capitalized String.		 */		public static function capitalize( string_:String, ...args_:Array ):String		{			return string_.toUpperCase( );		}		/**		 * Function for uncapitalizing a sequence of characters to be		 * used with String.replace() function.		 * @param string_ String The String to uncapitalize.		 * @param ...args_ Array Rest parameter for sub-matches.		 * @return String The uncapitalized String.		 */		public static function uncapitalize( string_:String, ...args_:Array ):String		{			return string_.toLowerCase( );		}	}}