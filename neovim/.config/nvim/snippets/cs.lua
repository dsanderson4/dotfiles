return {
    s(
            { trig = "sum", name = "Summary" },
            fmt(
            [[
                    /// <summary>{}</summary>
            {}
            ]],
            {
                i(1),
                i(0),
            })
    ),

    s(
            { trig = "sum", name = "Property Value" },
            fmt(
            [[
                    /// <value>{}</value>
            {}
            ]],
            {
                i(1),
                i(0),
            })
    ),

    s(
            { trig = "bc", name = "Belgrade Call" },
            fmt(
            [[
                    /// {}
            {}
            ]],
            {
                i(1),
                i(0),
            })
    ),

    s(
            { trig = "ch", name = "Class Header" },
            fmt(
            [[
                /// <summary>
                ///     {}
                /// </summary>
                /// <revision revisor="dave.anderson" date="{date}">
                ///     Class created.
                /// </revision>
            {}
            ]],
            {
                i(1),
                i(0),
                date = os.date("%m/%d/%y")
            })
    ),

    s(
            { trig = "gw", name = "Gets Whether" },
            fmt("Gets a value indicating whether ",
            {
            })
    ),

    s(
            { trig = "sw", name = "Sets Whether" },
            fmt("Sets a value indicating whether ",
            {
            })
    ),

    s(
            { trig = "gw", name = "Gets or Sets Whether" },
            fmt("Gets or Sets a value indicating whether ",
            {
            })
    ),

    s(
            { trig = "co", name = "Construct" },
            fmt("Initializes a new instance of the <see cref=\"{}\"/> class.",
            {
                i(1),
            })
    ),

    s(
            { trig = "cr", name = "Class Revision" },
            fmt(
            [[
                /// <revision revisor="dave.anderson" date="{date}">
                ///     {}
                /// </revision>
            {}
            ]],
            {
                i(1),
                i(0),
                date = os.date("%m/%d/%y")
            })
    ),

    s(
            { trig = "eh", name = "Enum Header" },
            fmt(
            [[
                /// <summary>
                ///     {}
                /// </summary>
                /// <revision revisor="dave.anderson" date="{date}">
                ///     created.
                /// </revision>
            {}
            ]],
            {
                i(1),
                i(0),
                date = os.date("%m/%d/%y")
            })
    ),

    s(
            { trig = "fh", name = "File Header" },
            fmt(
            [[
            // -----------------------------------------------------------------------------
            // <copyright file="{filename}" company="Dominion Voting Systems">
            //     Copyright (c) {year} Dominion Voting Systems, Inc. All Rights Reserved.
            //     Any distribution of source code by others is prohibited.
            // </copyright>
            // <summary>
            //     {}
            // </summary>
            // <revision revisor="dave.anderson" date="{date}">
            //     File Created.
            // </revision>
            // -----------------------------------------------------------------------------
            {}
            ]],
            {
                i(1),
                i(0),
                filename = vim.fn.expand("%"),
                year = os.date("%Y"),
                date = os.date("%m/%d/%y")
            })
    ),

    s(
            { trig = "fm", name = "File Modified" },
            fmt(
            [[
            // <revision revisor="dave.anderson" date="{date}">
            //     File Modified.
            // </revision>
            {}
            ]],
            {
                i(0),
                date = os.date("%m/%d/%y")
            })
    ),

    s(
            { trig = "mh", name = "Method Header" },
            fmt(
            [[
                    /// <summary>
                    ///     {}
                    /// </summary>
                    /// <revision revisor="dave.anderson" date="{date}">
                    ///     Method created.
                    /// </revision>
            {}
            ]],
            {
                i(1),
                i(0),
                date = os.date("%m/%d/%y")
            })
    ),

    s(
            { trig = "mp", name = "Method Parameter" },
            fmt(
            [[
                    /// <param name="{}">{}</param>
            {}
            ]],
            {
                i(1),
                i(2),
                i(0),
            })
    ),

    s(
            { trig = "mr", name = "Method Return" },
            fmt(
            [[
                    /// <returns>{}</returns>
            {}
            ]],
            {
                i(1),
                i(0),
            })
    ),

    s(
            { trig = "mv", name = "Method Revision" },
            fmt(
            [[
                    /// <revision revisor="dave.anderson" date="{date}">
                    ///     {}
                    /// </revision>
            {}
            ]],
            {
                i(1),
                i(0),
                date = os.date("%m/%d/%y")
            })
    ),

    s(
            { trig = "mt", name = "Method Tag" },
            fmt(
            [[
                    /// <{}>
                    /// </{}>
            {}
            ]],
            {
                i(1),
                rep(1),
                i(0),
            })
    ),

    s(
            { trig = "pb", name = "Property Body" },
            fmta(
            [[
                    public <> <>
                    {
                        get
                        {
                            return this.<>;
                        }
                        set
                        {
                            this.<> = value;
                        }
                    }

            <>
            ]],
            {
                i(1),
                i(2),
                i(3),
                rep(3),
                i(0),
            })
    ),

    s(
            { trig = "ex", name = "Exception" },
            fmt(
            [[
                    /// <exception cref="{}">
                    ///     {}
                    /// </exception>
            {}
            ]],
            {
                i(1),
                i(2),
                i(0),
            })
    ),


    s(
            { trig = "exu", name = "External Unit" },
            fmt(
            [[
                    /// <externalUnit cref="{}" />
            {}
            ]],
            {
                i(1),
                i(0),
            })
    ),
    s(
            { trig = "bch", name = "Belgrade Class Header" },
            fmt(
            [[
                /// <summary>
                ///     {}
                /// </summary>
                /// <Revisions>
                /// Initial Revision - {date} - dave.anderson #$
                /// </Revisions>
            {}
            ]],
            {
                i(1),
                i(0),
                date = os.date("%m/%d/%Y %I:%M %p")
            })
    ),

    s(
            { trig = "bcr", name = "Belgrade Class Revision" },
            fmt(
            [[
                /// {} - {date} - dave.anderson #$
            {}
            ]],
            {
                i(1),
                i(0),
                date = os.date("%m/%d/%Y %I:%M %p")
            })
    ),

    s(
            { trig = "bfh", name = "Belgrade File Header" },
            fmt(
            [[
            // --------------------------------------------------------------------------------------------------------------------
            // <copyright file="{filename}" company="Dominion Voting Systems Corporation">
            // Copyright {year} (c) Dominion Voting Systems Corporation
            // </copyright>
            // <summary>
            //      #ProjectName: {} #
            //  #AssemblyVersion: 1.0 #
            // </summary>
            // --------------------------------------------------------------------------------------------------------------------
            {}
            ]],
            {
                year = os.date("%Y"),
                filename = vim.fn.expand("%"),
                i(1),
                i(0),
            })
    ),

    s(
            { trig = "bmh", name = "Belgrade Method Header" },
            fmt(
            [[
                    /// <summary>
                    ///     {}
                    /// </summary>
                    /// <CallSequence>
                    /// </CallSequence>
                    /// <Revisions>
                    /// Initial Revision - {date} - dave.anderson #$
                    /// </Revisions>
            {}
            ]],
            {
                i(1),
                i(0),
                date = os.date("%m/%d/%Y %I:%M %p")
            })
    ),

    s(
            { trig = "bmr", name = "Belgrade Method Revision" },
            fmt(
            [[
                    /// {} - {date} - dave.anderson #$
            {}
            ]],
            {
                i(1),
                i(0),
                date = os.date("%m/%d/%Y %I:%M %p")
            })
    ),

    s(
            { trig = "bph", name = "Belgrade Property Header" },
            fmt(
            [[
                    /// <summary>
                    ///     {}
                    /// </summary>
                    /// <value>{}</value>
                    /// <CallSequence>
                    /// </CallSequence>
                    /// <Revisions>
                    /// Initial Revision - {date} - dave.anderson #$
                    /// </Revisions>
            {}
            ]],
            {
                i(1),
                i(2),
                i(0),
                date = os.date("%m/%d/%Y %I:%M %p")
            })
    ),
}
