# fedora-r-devel

Packaging R and R packages for Fedora: the Fedora Project's `r-devel` list, where its packagers of R and of CRAN and Bioconductor packages work things out. Not to be confused with R's own R-devel list at ETH Zurich.

The list lives on Fedora's Mailman 3 server. Its archive, from April 2006 on, is public at [lists.fedoraproject.org](https://lists.fedoraproject.org/archives/list/r-devel@lists.fedoraproject.org/), and that archive exports any span of months as an mbox file. This repository keeps a copy, laid out like the other archives in [r-mailing-lists](https://github.com/r-mailing-lists).

## How it is collected

`tools/update.sh` asks the archive for each month as an mbox file, and `tools/hyperkitty-to-mbox.py` writes it as a Mailman 2 text archive would: the headers such an archive keeps (From, Date, Subject, Message-ID, In-Reply-To, References) and the text, with every address in the sender, a subject or the text written `user at example.org`. A month already here is replaced only by a copy with at least as many messages.

## Structure

- `raw/` - one .mbox file per month with mail
- `processed/` - structured JSON from [rmail-parser](https://github.com/r-mailing-lists/rmail-parser), one file per month
- `meta.json` - list statistics
- `tools/` - the fetch and conversion scripts

## Updating

The **Update Archive** workflow runs daily and fetches this month and the one before. Run by hand, it takes months to fetch again. Locally (needs GNU date):

``` bash
tools/update.sh 2026-09 2026-10
```

## Viewer

Browse these archives at [r-mailing-lists.thecoatlessprofessor.com](https://r-mailing-lists.thecoatlessprofessor.com/lists/fedora-r-devel/)
