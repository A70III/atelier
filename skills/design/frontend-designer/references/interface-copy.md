# Interface Copy

Every string in an interface has a job: helping someone understand the screen, or helping them act
on it. Copy is built material like spacing and colour, so it gets the same intent, and each piece
of it carries one job rather than three.

## Writing it

**`COPY-AUDIENCE`** Write from the reader's side of the screen. Name a thing for what the person
sees themselves doing, not for the machinery underneath it. People manage their notification
settings, not a webhook table.

**`COPY-DESCRIBE`** State what a thing is and what it does. Persuasion belongs on a different page;
inside a working interface it makes the interface harder to operate.

**`COPY-ACTIVE`** Active voice, short ordinary verbs, sentence case, and no filler. Match the tone
to the brand and to who is reading.

**`COPY-ACTION-NAME`** A button says what will happen when it is pressed. "Save changes", rather
than "Submit". That name then holds for the whole journey: press "Publish" and the confirmation
reads "Published", not "Success". A vocabulary that stays put is how someone learns the product.

**`COPY-ERRORS`** An error names the cause and the way out, in the product's voice, never a
person's. It avoids apologising, and it never leaves the reader guessing about what happened.
"That email is already registered. Sign in, or use a different address." is an error message.
"Invalid input" is not.

**`COPY-EMPTY`** An empty screen is a chance to point somewhere: say what would appear here, and how
to make it appear. A blank panel that shrugs wastes the moment of highest attention.

**`COPY-LENGTH`** A headline is a handful of words. A supporting paragraph is a sentence or two, not
a paragraph. A testimonial fits in a glance. When the copy does not fit, cut the copy: a value
proposition that genuinely needs a paragraph is a proposition problem, not a layout problem.

**`COPY-LANGUAGE`** When the interface is not in English, keep the intent of every rule here and
drop the parts that are English-specific: sentence case, typographic quotation marks, and
capitalisation conventions do not transfer. Register, brevity, plain verbs, active voice where the
language has it, and the em-dash ban do.

**`COPY-REGISTER`** One voice for the page. Mixing technical mono, editorial prose, and marketing
punch reads as three authors, unless the brand's voice genuinely works that way.

**`COPY-PLACEHOLDERS`** When the brief supplies no content, invent content that fits the subject:
real-sounding names, roles, and details appropriate to the locale. Placeholder text that reads as
placeholder, or names borrowed from the first example in the model's memory, undoes the rest of the
design.

## Auditing it

Before finishing, re-read every string a person will see: headlines, labels, buttons, body copy,
captions, alternative text, footer text, empty states, and error messages. Rewrite any string that
fails one of these tests.

**`COPY-AUDIT-GRAMMAR`** Grammatically broken, or assembled from fragments that do not agree. If it
cannot be read aloud without a stumble, it is wrong.

**`COPY-AUDIT-REFERENT`** Refers to something the reader has not been given. A pronoun or a phrase
with no visible antecedent fails.

**`COPY-AUDIT-MOCK`** Reads as machine-written: cute-but-wrong wordplay, a forced metaphor that does
not track, a phrase that sounds thoughtful while saying nothing.

**`COPY-AUDIT-CRAFTSMAN`** Performs craft instead of describing a product: whispered humility, mock
poetic labels, a section heading that is a mood rather than a name. Plain functional labels win:
"Testimonials", "Recent writing", "In progress".

**`COPY-AUDIT-METRIC`** Presents an invented figure as fact. Every number either comes from the
brand or the brief, or is visibly labelled as sample data. Precision a brand never claimed is not
polish, it is fabrication.

**`COPY-AUDIT-JARGON`** Uses internal names, internal team vocabulary, or an industry abbreviation
that the audience would not say out loud.

## Marks and punctuation

**`COPY-EMDASH`** No em dash and no separator en dash anywhere a person can see one: headline, label,
pill, button, caption, quote, attribution, alternative text, or body copy. Use a hyphen, a period, a
comma, a colon, or parentheses. Ranges use a plain hyphen. This is a hard rule, because the em dash
is the most reliable single sign of machine-written interface copy.

**`COPY-QUOTES`** Use typographic quotation marks and apostrophes, or none at all. Straight ASCII
marks read as unfinished in polished interface copy.

**`COPY-CASE`** Sentence case for labels and interface text. A label in full caps is a deliberate
treatment, not a habit, and it never wraps a long phrase.

**`COPY-BREAKS`** Let a headline break where it breaks. A hard line break inserted to italicise the
last two words is a device; reserve it for briefs that ask for that move, and the line reads
naturally first.

## Labels on real things

**`COPY-LOGOWALL`** A logo wall is logos. No category label under each mark, no invented
one-word summary of what the company does.

**`COPY-CAPTION`** A real photograph of a real person can carry a real credit. Stock imagery dressed
in a fictitious credit line, or in a plate number, is decoration pretending to be provenance.

**`COPY-ATTRIBUTION`** Attribute a quote with a name and a role, and optionally a company. A first
name alone is not an attribution.

**`COPY-ALT`** Alternative text describes what the image contributes to the page, written the way
the product speaks, without repeating a caption that sits directly beneath it.
