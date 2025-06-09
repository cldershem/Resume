#import "@preview/fontawesome:0.5.0": fa-github, fa-gitlab, fa-phone, fa-envelope, fa-map-location-dot, fa-link

#let coverletter(letter) = [
  #datetime.today().display("[month repr:long] [day], [year]") \
  Re: #letter.company \
  #letter.title
  #linebreak()
  #linebreak()
  #letter.attn #sym.dash
  
  #letter.letter
  #linebreak()
  #sym.dash.em Cameron Dershem
  #linebreak()

  #if letter.keys().contains("cites") [
    #for citation in letter.cites [
      #sym.dash.en #citation
    ]
  ]
]

#let header(bio) = box()[
    #grid(
      rows: (auto, auto),
      columns: (.33fr, auto),
      align(left, text(2.75em)[
        #bio.name
      ]),
      align(right)[
        // #fa-envelope()
        #bio.email
        #sym.divides
        // #fa-phone()
        #bio.phone 
        #sym.divides
        // #fa-map-location-dot()
        #bio.location
        #linebreak()
        // #fa-link() 
        #bio.website          
        #sym.divides
        // #fa-github()
        #bio.github
        #sym.divides
        // #fa-gitlab()
        #bio.gitlab
      ]
    )
   #line(length: 100%)
  ]

#let job_header(job) = block(
    below: 8pt,
    stroke: (top: (paint: gray, thickness: 1pt)),
    outset: (top: 4pt, right: 4.5pt)
  )[
  #grid(
    columns: (1.25fr, .75fr),
    align(left)[
      *#job.name*\
      #smallcaps(job.title)
    ],
    align(right)[
      #smallcaps(job.location)\
      #smallcaps(job.start_date)
      #sym.dash.em
      #smallcaps(job.end_date)
    ]
  )
]

#let education(edu) = box[
  #grid(
    columns: (1.25fr, .75fr),
    align(left)[
      *#edu.school*
      #linebreak()
      #smallcaps(edu.major)
      #sym.dash.em
      #smallcaps(edu.concentration)
    ],
    align(right)[
      #smallcaps(edu.location)
      #linebreak()
      #smallcaps(edu.start_date)
      #sym.dash.em
      #smallcaps(edu.end_date)
    ]
  )
]

#let backtick = (axum: raw("`axum`"))

#let techstack(stack) = box(
    inset: (left: 1em), 
    fill: color.luma(80%),
    width: 100%,
    outset: (bottom: 5pt, top: 3pt)
  )[
    #stack.join(", ")
]

#let contract(sub) = box(inset: (bottom: 4pt))[
  *#sub.name*
  #if sub.keys().contains("stack") [
    #techstack(sub.stack)
  ]
  #for desc in sub.description {
    list(desc)
  }
]

#let project(proj) = box[
  *#proj.name*
  #if proj.keys().contains("outcome") {
    sym.dash.em
    text(weight: "bold")[
      #proj.outcome
    ]
  }
  #linebreak()
  #for desc in proj.description [
    - #desc 
  ]
]

#let experience(experiences) = block()[

  #for ex in experiences {
    block(
      inset: (
        top: 4pt,
        right: 4pt
      ),
      stroke: ( 
        right: (paint: gray, thickness: 1pt),
        // top: (paint: gray, thickness: 1pt) 
      ),
      [
        #job_header(ex)
          #if ex.keys().contains("phb") {
            block(
              inset: (
                top: 0pt, 
                bottom: -4pt,
                rest: 7pt
              ),
              for sub in ex.phb.values() {
                contract(sub)
              }
            )
          } else {
            if ex.keys().contains("stack") [
              #techstack(ex.stack)
            ]
            for desc in ex.description [
              - #desc
            ]
          }
      ]
    )
  }
]