#
# Copyright 2009 Huygens Instituut for the History of the Netherlands, Den Haag, The Netherlands.
#
# This file is part of New Women Writers.
#
# New Women Writers is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# New Women Writers is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with New Women Writers.  If not, see <http://www.gnu.org/licenses/>.
#

module TMail

  class TMailScanner

    Version = '1.2.3'
    Version.freeze

    MIME_HEADERS = {
      :CTYPE        => true,
      :CENCODING    => true,
      :CDISPOSITION => true
    }

    alnum      = 'a-zA-Z0-9'
    atomsyms   = %q[  _#!$%&`'*+-{|}~^/=?  ].strip
    tokensyms  = %q[  _#!$%&`'*+-{|}~^@.    ].strip
    atomchars  = alnum + Regexp.quote(atomsyms)
    tokenchars = alnum + Regexp.quote(tokensyms)
    iso2022str = '\e(?!\(B)..(?:[^\e]+|\e(?!\(B)..)*\e\(B'

    eucstr  = "(?:[\xa1-\xfe][\xa1-\xfe])+"
    sjisstr = "(?:[\x81-\x9f\xe0-\xef][\x40-\x7e\x80-\xfc])+"
    utf8str = "(?:[\xc0-\xdf][\x80-\xbf]|[\xe0-\xef][\x80-\xbf][\x80-\xbf])+"

    quoted_with_iso2022  = /\A(?:[^\\\e"]+|#{iso2022str})+/n
    domlit_with_iso2022  = /\A(?:[^\\\e\]]+|#{iso2022str})+/n
    comment_with_iso2022 = /\A(?:[^\\\e()]+|#{iso2022str})+/n

    quoted_without_iso2022  = /\A[^\\"]+/n
    domlit_without_iso2022  = /\A[^\\\]]+/n
    comment_without_iso2022 = /\A[^\\()]+/n

    PATTERN_TABLE = {}
    PATTERN_TABLE['EUC'] =
      [
        /\A(?:[#{atomchars}]+|#{iso2022str}|#{eucstr})+/n,
        /\A(?:[#{tokenchars}]+|#{iso2022str}|#{eucstr})+/n,
        quoted_with_iso2022,
        domlit_with_iso2022,
        comment_with_iso2022
      ]
    PATTERN_TABLE['SJIS'] =
      [
        /\A(?:[#{atomchars}]+|#{iso2022str}|#{sjisstr})+/n,
        /\A(?:[#{tokenchars}]+|#{iso2022str}|#{sjisstr})+/n,
        quoted_with_iso2022,
        domlit_with_iso2022,
        comment_with_iso2022
      ]
    PATTERN_TABLE['UTF8'] =
      [
        /\A(?:[#{atomchars}]+|#{utf8str})+/n,
        /\A(?:[#{tokenchars}]+|#{utf8str})+/n,
        quoted_without_iso2022,
        domlit_without_iso2022,
        comment_without_iso2022
      ]
    PATTERN_TABLE['NONE'] =
      [
        /\A[#{atomchars}]+/n,
        /\A[#{tokenchars}]+/n,
        quoted_without_iso2022,
        domlit_without_iso2022,
        comment_without_iso2022
      ]


    def initialize( str, scantype, comments )
      init_scanner str
      @comments = comments || []
      @debug    = false

      # fix scanner mode
      @received  = (scantype == :RECEIVED)
      @is_mime_header = MIME_HEADERS[scantype]

      atom, token, @quoted_re, @domlit_re, @comment_re = PATTERN_TABLE[TMail.KCODE]
      @word_re = (MIME_HEADERS[scantype] ? token : atom)
    end

    attr_accessor :debug

    def scan( &block )
      if @debug
        scan_main do |arr|
          s, v = arr
          printf "%7d %-10s %s\n",
                 rest_size(),
                 s.respond_to?(:id2name) ? s.id2name : s.inspect,
                 v.inspect
          yield arr
        end
      else
        scan_main(&block)
      end
    end

    private

    RECV_TOKEN = {
      'from' => :FROM,
      'by'   => :BY,
      'via'  => :VIA,
      'with' => :WITH,
      'id'   => :ID,
      'for'  => :FOR
    }

    def scan_main
      until eof?
        if skip(/\A[\n\r\t ]+/n)   # LWSP
          break if eof?
        end

        if s = readstr(@word_re)
          if @is_mime_header
            yield [:TOKEN, s]
          else
            # atom
            if /\A\d+\z/ === s
              yield [:DIGIT, s]
            elsif @received
              yield [RECV_TOKEN[s.downcase] || :ATOM, s]
            else
              yield [:ATOM, s]
            end
          end

        elsif skip(/\A"/)
          yield [:QUOTED, scan_quoted_word()]

        elsif skip(/\A\[/)
          yield [:DOMLIT, scan_domain_literal()]

        elsif skip(/\A\(/)
          @comments.push scan_comment()

        else
          c = readchar()
          yield [c, c]
        end
      end

      yield [false, '$']
    end

    def scan_quoted_word
      scan_qstr(@quoted_re, /\A"/, 'quoted-word')
    end

    def scan_domain_literal
      '[' + scan_qstr(@domlit_re, /\A\]/, 'domain-literal') + ']'
    end

    def scan_qstr( pattern, terminal, type )
      result = ''
      until eof?
        if    s = readstr(pattern) then result << s
        elsif skip(terminal)       then return result
        elsif skip(/\A\\/)         then result << readchar()
        else
          raise "TMail FATAL: not match in #{type}"
        end
      end
      scan_error! "found unterminated #{type}"
    end

    def scan_comment
      result = ''
      nest = 1
      content = @comment_re

      until eof?
        if s = readstr(content) then result << s
        elsif skip(/\A\)/)      then nest -= 1
                                     return result if nest == 0
                                     result << ')'
        elsif skip(/\A\(/)      then nest += 1
                                     result << '('
        elsif skip(/\A\\/)      then result << readchar()
        else
          raise 'TMail FATAL: not match in comment'
        end
      end
      scan_error! 'found unterminated comment'
    end

    # string scanner

    def init_scanner( str )
      @src = str
    end

    def eof?
      @src.empty?
    end

    def rest_size
      @src.size
    end

    def readstr( re )
      if m = re.match(@src)
        @src = m.post_match
        m[0]
      else
        nil
      end
    end

    def readchar
      readstr(/\A./)
    end

    def skip( re )
      if m = re.match(@src)
        @src = m.post_match
        true
      else
        false
      end
    end

    def scan_error!( msg )
      raise SyntaxError, msg
    end

  end

end   # module TMail
#:startdoc: