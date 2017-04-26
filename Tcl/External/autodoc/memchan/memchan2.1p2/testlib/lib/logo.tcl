# This file contains generic support code for test suites built along the
# lines of the Tcl test suite and the suites of various extensions.
#
# Copyright (c) 1999 Andreas Kupries, <akupries@westend.com>
#
# -- splash definitions required by the tester --

global _splashImage
set    _splashImage {}

proc splashTclLogo {} {
    global _splashImage

    if {$_splashImage != {}} {
	return $_splashImage
    }

    set _splashImage [image create photo -data {
	R0lGODlhRABkAPf/AP//////zP//mf//Zv//M///AP/M///MzP/Mmf/MZv/MM//M
	AP+Z//+ZzP+Zmf+ZZv+ZM/+ZAP9m//9mzP9mmf9mZv9mM/9mAP8z//8zzP8zmf8z
	Zv8zM/8zAP8A//8AzP8Amf8AZv8AM/8AAMz//8z/zMz/mcz/Zsz/M8z/AMzM/8zM
	zMzMmczMZszMM8zMAMyZ/8yZzMyZmcyZZsyZM8yZAMxm/8xmzMxmmcxmZsxmM8xm
	AMwz/8wzzMwzmcwzZswzM8wzAMwA/8wAzMwAmcwAZswAM8wAAJn//5n/zJn/mZn/
	Zpn/M5n/AJnM/5nMzJnMmZnMZpnMM5nMAJmZ/5mZzJmZmZmZZpmZM5mZAJlm/5lm
	zJlmmZlmZplmM5lmAJkz/5kzzJkzmZkzZpkzM5kzAJkA/5kAzJkAmZkAZpkAM5kA
	AGb//2b/zGb/mWb/Zmb/M2b/AGbM/2bMzGbMmWbMZmbMM2bMAGaZ/2aZzGaZmWaZ
	ZmaZM2aZAGZm/2ZmzGZmmWZmZmZmM2ZmAGYz/2YzzGYzmWYzZmYzM2YzAGYA/2YA
	zGYAmWYAZmYAM2YAADP//zP/zDP/mTP/ZjP/MzP/ADPM/zPMzDPMmTPMZjPMMzPM
	ADOZ/zOZzDOZmTOZZjOZMzOZADNm/zNmzDNmmTNmZjNmMzNmADMz/zMzzDMzmTMz
	ZjMzMzMzADMA/zMAzDMAmTMAZjMAMzMAAAD//wD/zAD/mQD/ZgD/MwD/AADM/wDM
	zADMmQDMZgDMMwDMAACZ/wCZzACZmQCZZgCZMwCZAABm/wBmzABmmQBmZgBmMwBm
	AAAz/wAzzAAzmQAzZgAzMwAzAAAA/wAAzAAAmQAAZgAAM+4AAN0AALsAAKoAAIgA
	AHcAAFUAAEQAACIAABEAAADuAADdAAC7AACqAACIAAB3AABVAABEAAAiAAARAAAA
	7gAA3QAAuwAAqgAAiAAAdwAAVQAARAAAIgAAEe7u7t3d3bu7u6qqqoiIiHd3d1VV
	VURERCIiIhEREQAAACwAAAAARABkAAAI/wABCBxIsKDBgwgTKlzIsKHAevYOSHRA
	UYaMGTky5nDgsOPAevUkHkBA0YFFjBl1AFm5MojLlzBjAplxwGNCByxbxtzJs6fP
	IBvrMQQZcWJNADJ+Kl2qFMjGixpzqMwZU4ZAB0yzat26kyMArFzDivWJ4OrYs2iD
	HAWbtq3Wowfcyl0KRCiAuG2PHJnrE8hAvFr37tyxg29PvwIBMz2yY8EOwUciFCjw
	2HBMHQPtcV2w4CXjyREKW4aZ4yOQrJ8r7+X8WPBol6Ufnl4cobPLyAWCuH7tcgbB
	2UsjR3BdoMbunXr1trU6EPjS0HuP1LDdc+9GnMfDehXoXCl0lwuMV/8HchSAPSDZ
	t24H0N2n9Ns7cqc/osMegHpPqtRzkP4tQR2oiRYEZ9XpIFQVyDijoBXtbVUeADlw
	tRdl2R1RVz2kKKghMl2gZd9AEW71mW4xWXiAPQlqqCEZZ9VFUIiB1cbTEQiokKKK
	zpCBTYsFwaiVY8cd8QCGODqDzCE7wpRciT1h9mJYQCpZWoZFrsLTDqHBF+VOsQ00
	g4gD8nRAHkUqyOJONRRA3YBrklZQUoE1VmIO9pTpDJLIBaGmZzLy1KVAcAYYwU4I
	kFmkKrMpd5uew91WQ6M7MTcQW4th6ZqFKJapYxBOwZiaazWQ2FVBlAZH2KUPGIrj
	IZzKYJcO0cX/p9V6X4l4KkwOUInjKqog42seEEZXW387PVgrWkCscKOdzgQCwAyC
	bbmUsQigRV8VzKrYRbCrbfXhX9bmoGq2peWg16PEymQXuGcdkYOuzK7CEXpBDJou
	TIgRpFhY7sJr5yESkQgpU/myO5a7y9o5Rj0y6HVrVk4SdF67OSRcZg710CtgVn/K
	huyyyPi7Ckn3+tQxd8jiSErC+hxAr1iS/paWKhoekk/CVjxQsk8xN5fWKitaAXKg
	Y9GKsljYHaIhENiqqE+DW5VlEIBiSQTEPgquIq6KVrZlrEBUh1WTPVQeMsO4uu38
	09cQjnWACisriIgDnazIQUbIrvtk1U+o/0jGPbquAkhEyCLkY9SqrpKsv/fwx+NB
	h2tVqIaKZ6qiPRWozVPB/4l1hAOJ17UsKfXA+vjUnjtghYb71LcsIBnnfRDUSgm5
	upGI0LmsFQHQTrDePvObgwwKIpO7jSpasa9Y38rMrw7EG0lGBSrgKMPyYs8+FhAy
	AI0MGTk4gaMO2HP1dexiAeEA0Dk+ID7lQCDgO1Pnz//TA4GYOcP7WavfltGaOVgF
	9KE//t3pAY5Di9HKtxgL5EN6+1PRGOSnuZ4sEFkP/F74VJSDl6GlZ3dJSw7kRifK
	wcZ+SgEhAxejgwTlznLTswf6zuKbgqyQYBk6RA6QZyUg4COAaDlZqf8kFIRVHAlj
	CVoF0EhxQ6YI8WAZOcIhkKG4eoxuiGF5oucwcwBAOKOKy6pCAs+iRbflIUVAIJuK
	VmCutERsUhRTFRkOoCsmorApBiEazKiEiMkpKB86awvnkGItINwjQYcAnYZkcEc8
	FuRLhcQHFR3QNEBkzi2DhGQh80GKHPTNGR2Si4v2lpYjkGEfOVBW1+bSvLbNJY2H
	ONNcjBW5reiAIjBx2b2A8AAEtHFaPUKO5soCHF8G6Tjl2hktd+IU1DgAfZ+DVkyk
	IqVgMUVqAwnbbebFpO58DpozGKOFvnKpcnFKJxYsiDZN9JWXucsBGwHONxO1kZg8
	4C6eKlf8HlD/y5fQqj3cvI1fIoQUyDwTOPG7zLFuU64caNIn/yxRQHVjldN00DMH
	hYn8POMXcZbmABm7V8+8OS+DskdR25zh5345To9+JYTpGqlEAVBNWDUzpUqagTR1
	09FyQqg0WIRJDT2mJKvAE1c4mYHpgkC+enjqlvgKyQxmo7521gQnJiPIDEkTOR2o
	BF8swRdWX+IU5+QkrFnNTHUqxFYuOQelnonrT/7UxO0Z5o115Y0t9aVXvhQsr30l
	GF8Di0mCBJWwXBnlQhHrITgyNi3lOexjsxLZ7a1kKmdtpIMGokeyrkQjMqCIRGSY
	EKKIRCQlKclJUBIVr2Y2shkJrQNGCzybCtj2trjNrW4HEhAAOw==
    }
    ]

    return $_splashImage
}

