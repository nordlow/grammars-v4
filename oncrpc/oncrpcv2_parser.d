/// Automatically generated from `oncrpcv2.g4`.
module oncrpcv2_parser;

alias Input = const(char)[];

struct Match
{
@safe pure nothrow @nogc:
    static Match zero()
    {
        return typeof(return)(0);
    }
    static Match none()
    {
        return typeof(return)(_length.max);
    }
    /// Match length in number of UTF-8 chars or 0 if empty.
    @property uint length()
    {
        return _length;
    }
    bool opCast(U : bool)() const
    {
        return _length != _length.max;
    }
    this(size_t length)
    {
        assert(length <= _length.max);
        this._length = cast(typeof(_length))length;
    }
    const uint _length;                // length == uint.max is no match
}

struct Parser
{
@safe:
    Input inp;                  ///< Input.
    size_t off;                 ///< Current offset into inp.

    Match EOF() pure nothrow @nogc
    {
        pragma(inline, true);
        if (inp[off] == '\r' &&
            inp[off + 1] == '\n') // Windows
        {
            off += 2;
            return Match(2);
        }
        if (inp[off] == '\n' || // Unix/Linux
            inp[off] == '\r')   // Mac?
        {
            off += 1;
            return Match(1);
        }
        return Match.none();
    }

    Match any() pure nothrow @nogc
    {
        pragma(inline, true);
        if (off == inp.length)  // TODO:
            return Match.none();
        off += 1;
        return Match(1);
    }

    Match ch(const char x) pure nothrow @nogc
    {
        pragma(inline, true);
        if (off == inp.length)  // TODO:
            return Match.none();
        if (inp[off] == x)
        {
            off += 1;
            return Match(1);
        }
        return Match.none();
    }

    Match dch(const dchar x) pure nothrow @nogc
    {
        import std.typecons : Yes;
        import std.utf : encode;
        char[4] ch4;
        const replacementChar = cast(dchar) 0x110000;
        const n = encode!(Yes.useReplacementDchar)(ch4, replacementChar);
        if (ch4[0 .. n] == [239, 191, 189]) // encoding of replacementChar
            return Match.none();
        if (off + n > inp.length) // TODO:
            return Match.none();
        if (inp[off .. off + n] == ch4[0 .. n])
        {
            off += n;
            return Match(n);
        }
        return Match.none();
    }

    Match cc(string cclass)() pure nothrow @nogc
    {
        pragma(inline, true);
        off += 1;               // TODO: switch on cclass
        if (off > inp.length)   // TODO:
            return Match.none();
        return Match(1);
    }

    /// Match string x.
    Match str(const scope string x) pure nothrow @nogc
    {
        pragma(inline, true);
        if (off + x.length <= inp.length && // TODO: optimize by using null-sentinel
            inp[off .. off + x.length] == x) // inp[off .. $].startsWith(x)
        {
            off += x.length;
            return Match(x.length);
        }
        return Match.none();
    }

    Match seq(Matchers...)(const scope lazy Matchers matchers)
    {
        const off0 = off;
        static foreach (const matcher; matchers)
        {{                      // scoped
            const match = matcher;
            if (!match)
            {
                off = off0;     // backtrack
                return match;   // propagate failure
            }
        }}
        return Match(off - off0);
    }

    Match alt(Matchers...)(const scope lazy Matchers matchers)
    {
        static foreach (const matcher; matchers)
        {{                      // scoped
            const off0 = off;
            if (const match = matcher)
                return match;
            else
                off = off0;     // backtrack
        }}
        return Match.none();
    }

    Match not(Matcher)(const scope lazy Matcher matcher)
    {
        const off0 = off;
        const match = matcher;
        if (!match)
            return match;
        off = off0;             // backtrack
        return Match.none();
    }

    Match altNch(chars...)() pure nothrow @nogc
    {
        pragma(inline, true);
        import std.algorithm.comparison : among; // TODO: replace with switch
        if (inp[off].among!(chars))
        {
            off += 1;
            return Match(1);
        }
        return Match.none();
    }

    Match rng(in char lower, in char upper) pure nothrow @nogc
    {
        pragma(inline, true);
        const x = inp[off];
        if (lower <= x &&
            x <= upper)
        {
            off += 1;
            return Match(1);
        }
        return Match.none();
    }

    Match rng(in dchar lower, in dchar upper) pure nothrow @nogc
    {
        pragma(inline, true);
        // TODO: decode dchar at inp[off]
        const x = inp[off];
        if (lower <= x &&
            x <= upper)
        {
            off += 1; // TODO: handle dchar at inp[off]
            return Match(1);
        }
        return Match.none();
    }

    Match gzm(Matcher)(const scope lazy Matcher matcher)
    {
        const off0 = off;
        while (true)
        {
            const off1 = off;
            const match = matcher;
            if (!match)
            {
                off = off1;     // backtrack
                break;
            }
        }
        return Match(off - off0);
    }

    Match gzo(Matcher)(const scope lazy Matcher matcher)
    {
        const off0 = off;
        const match = matcher;
        if (!match)
        {
            off = off0;         // backtrack
            return Match.none();
        }
        return Match(off - off0);
    }

    Match gom(Matcher)(const scope lazy Matcher matcher)
    {
        const off0 = off;
        const match0 = matcher;
        if (!match0)
        {
            off = off0;         // backtrack
            return Match.none();
        }
        while (true)
        {
            const off1 = off;
            const match1 = matcher;
            if (!match1)
            {
                off = off1;     // backtrack
                break;
            }
        }
        return Match(off - off0);
    }

    Match nzo(Matcher1, Matcher2)(const scope lazy Matcher1 matcher, Matcher2 terminator)
    {
        const off0 = off;
        if (terminator)
        {
            off = off0;         // backtrack
            return Match.zero(); // done
        }
        off = off0;             // backtrack
        const match = matcher;
        if (!match)
        {
            off = off0;         // backtrack
            return Match.none();
        }
        return Match(off - off0);
    }

    Match nzm(Matcher1, Matcher2)(const scope lazy Matcher1 matcher, Matcher2 terminator)
    {
        const off0 = off;
        while (true)
        {
            const off1 = off;
            if (terminator)
            {
                off = off1;     // backtrack
                return Match(off1 - off0); // done
            }
            off = off1;         // backtrack
            const off2 = off;
            const match = matcher;
            if (!match)
            {
                off = off2;     // backtrack
                break;
            }
        }
        return Match(off - off0);
    }

    Match nom(Matcher1, Matcher2)(const scope lazy Matcher1 matcher, Matcher2 terminator)
    {
        const off0 = off;
        bool firstFlag;
        while (true)
        {
            const off1 = off;
            if (terminator)
            {
                off = off1;     // backtrack
                return Match(off1 - off0); // done
            }
            off = off1;         // backtrack
            const off2 = off;
            const match = matcher;
            if (!match)
            {
                off = off2;     // backtrack
                break;
            }
            firstFlag = true;
        }
        if (!firstFlag)
        {
            off = off0;         // backtrack
            return Match.none();
        }
        return Match(off - off0);
    }

    Match syn(Matcher)(const scope lazy Matcher matcher)
    {
        return Match.zero(); // pass, backtracking is performed by default
    }

    Match m__programDef()
    {
        return str(`program`);
    }
} // struct Parser
