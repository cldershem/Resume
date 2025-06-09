#let details = toml("data.toml")
#let letter = toml("coverletters/AbendHealth.toml")
#import "lib.typ": *

#set page(
  paper: "us-letter",
  margin: (
    left: 1.25cm,
    right: 1.25cm,
    top: 2.5cm,
    bottom: 1cm,
  ),
  header-ascent: 20%,
  header: header(details.bio),
)
#set par(linebreaks: "optimized")

#coverletter(letter)
#pagebreak()

#let skills = (
  for (section, items) in details.skills.pairs() [
    #box[
      #strong(section)
      #linebreak()
      #for item in items [
        #item
        #linebreak()
      ]
    ]
  ],
)

#let skills = [
  #box(height: 16em, outset: (bottom: -5pt))[
    #grid(
      columns: (.25fr, .75fr),
      column-gutter: -100pt,
      heading("Skills"),
      columns(
        4,
        [
          #heading(level: 2, "Languages")
          #for item in details.skills.at("Languages") [
            #item
            #linebreak()
          ]
          #heading(level: 2, "Tools")
          #for item in details.skills.at("Tools") [
            #item
            #linebreak()
          ]
          #heading(level: 2, "Technologies")
          #for item in details.skills.at("Technologies") [
            #item
            #linebreak()
          ]
          #heading(level: 2, "OSes")
          #for item in details.skills.at("OSes") [
            #item
            #linebreak()
          ]
          #colbreak()
          #heading(level: 2, "Keywords")
          #for item in details.skills.at("Keywords") [
            #item
            #linebreak()
          ]
          /*
          #heading(level: 2, "Soft Skills")
          #for item in details.skills.at("Soft Skills") [
            #item
            #linebreak()
          ]
          */
        ],
      ),
    )
  ]
]

#let resume = [
  #grid(
    columns: (.25fr, .75fr),
    column-gutter: -3em,
    heading("Professional Summary"), text(details.bio.summary),
  )

  #line(length: 100%)

  #grid(
    columns: (.25fr, .75fr),
    column-gutter: -25pt,
    heading("Experience"), experience(details.experience),
  )

  #line(length: 100%)

  #grid(
    columns: (.25fr, .75fr),
    column-gutter: -25pt,
    heading("Education"), education(details.education),
  )

  #line(length: 100%)

  #grid(
    columns: (.25fr, .75fr),
    column-gutter: -25pt,
    heading("Notable Public Projects"),
    [
      #for proj in details.projects {
        project(proj)
        linebreak()
      }
    ],
  )

  #line(length: 100%)
  #skills
]

#resume
