crystal_doc_search_index_callback({"repository_name":"assert-diff","body":"# assert-diff\n[![CI](https://github.com/YusukeHosonuma/assert-diff/actions/workflows/main.yaml/badge.svg)](https://github.com/YusukeHosonuma/assert-diff/actions/workflows/main.yaml)\n[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://yusukehosonuma.github.io/assert-diff/)\n[![GitHub release](https://img.shields.io/github/release/YusukeHosonuma/assert-diff.svg)](https://github.com/YusukeHosonuma/assert-diff/releases)\n\nAssert equals with readable diff report.\n\n![screenshot](https://github.com/YusukeHosonuma/assert-diff/raw/main/image/screenshot.png)\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   development_dependencies:\n     assert-diff:\n       github: YusukeHosonuma/assert-diff\n       branch: main\n   ```\n\n2. Run `shards install`\n\n## Example\n\nUse in specs:\n\n```crystal\nrequire \"assert-diff\"\n\ndescribe Rectangle do\n  it \"example\" do\n    actual = Rectangle.new(Point.new(0, 0), 4, 3, \"One\\nTwo\\nThree\")\n    expected = Rectangle.new(Point.new(0, 1), 4, 7, \"One\\nTwo\\nFour\")\n\n    actual.should eq_diff expected # or use `eq_full_diff`\n  end\nend\n```\n\nor use `assert_diff` and `assert_diff_full`.\n\n```crystal\nassert_diff(a, b)\nassert_diff_full(a, b)\n```\n\nUse to output:\n\n```crystal\nprint_diff(a, b)\nprint_diff_full(a, b)\n```\n\n## Contributing\n\nI don't think it can be used for edge cases.  \nIssues and PRs are welcome.\n\n1. Fork it (<https://github.com/YusukeHosonuma/assert-diff/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [Yusuke Hosonuma](https://github.com/YusukeHosonuma) - creator and maintainer\n","program":{"html_id":"assert-diff/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"superclass":null,"ancestors":[{"html_id":"assert-diff/Spec/Methods","kind":"module","full_name":"Spec::Methods","name":"Methods"},{"html_id":"assert-diff/Spec/Expectations","kind":"module","full_name":"Spec::Expectations","name":"Expectations"}],"locations":[],"repository_name":"assert-diff","program":true,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[{"html_id":"assert-diff/Spec/Expectations","kind":"module","full_name":"Spec::Expectations","name":"Expectations"},{"html_id":"assert-diff/Spec/Methods","kind":"module","full_name":"Spec::Methods","name":"Methods"}],"extended_modules":[{"html_id":"assert-diff/Spec/Expectations","kind":"module","full_name":"Spec::Expectations","name":"Expectations"},{"html_id":"assert-diff/Spec/Methods","kind":"module","full_name":"Spec::Methods","name":"Methods"}],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[{"id":"assert_diff(before:A,after:B,file=__FILE__,line=__LINE__)forallA,B-class-method","html_id":"assert_diff(before:A,after:B,file=__FILE__,line=__LINE__)forallA,B-class-method","name":"assert_diff","doc":"The same as `.eq_diff`, but this can be used independently.\n\n```\nassert_diff(x, y)\n```","summary":"<p>The same as <code><a href=\"toplevel.html#eq_diff(value)-class-method\">.eq_diff</a></code>, but this can be used independently.</p>","abstract":false,"args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":"A"},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":"B"},{"name":"file","doc":null,"default_value":"__FILE__","external_name":"file","restriction":""},{"name":"line","doc":null,"default_value":"__LINE__","external_name":"line","restriction":""}],"args_string":"(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B","args_html":"(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B","location":{"filename":"src/assert-diff/assert.cr","line_number":49,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/assert.cr#L49"},"def":{"name":"assert_diff","args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":"A"},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":"B"},{"name":"file","doc":null,"default_value":"__FILE__","external_name":"file","restriction":""},{"name":"line","doc":null,"default_value":"__LINE__","external_name":"line","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"assert_diff_internal(before, after, file, line, true)"}},{"id":"assert_diff_full(before:A,after:B,file=__FILE__,line=__LINE__)forallA,B-class-method","html_id":"assert_diff_full(before:A,after:B,file=__FILE__,line=__LINE__)forallA,B-class-method","name":"assert_diff_full","doc":"The same as `.eq_diff_full`, but this can be used independently.\n\n```\nassert_diff_full(x, y)\n```","summary":"<p>The same as <code><a href=\"toplevel.html#eq_diff_full(value)-class-method\">.eq_diff_full</a></code>, but this can be used independently.</p>","abstract":false,"args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":"A"},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":"B"},{"name":"file","doc":null,"default_value":"__FILE__","external_name":"file","restriction":""},{"name":"line","doc":null,"default_value":"__LINE__","external_name":"line","restriction":""}],"args_string":"(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B","args_html":"(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B","location":{"filename":"src/assert-diff/assert.cr","line_number":58,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/assert.cr#L58"},"def":{"name":"assert_diff_full","args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":"A"},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":"B"},{"name":"file","doc":null,"default_value":"__FILE__","external_name":"file","restriction":""},{"name":"line","doc":null,"default_value":"__LINE__","external_name":"line","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"assert_diff_internal(before, after, file, line, false)"}},{"id":"eq_diff(value)-class-method","html_id":"eq_diff(value)-class-method","name":"eq_diff","doc":"The same as `.eq`, but print readable diff report if actual not equals *value* (`!=`).\n\n```\nx = {a: 1, b: 2, c: 0}\ny = {a: 1, b: 2, c: 3}\n\nx.should eq_diff y\n\n# =>\n# Expected: {a: 1, b: 2, c: 3}\n#      got: {a: 1, b: 2, c: 0}\n#     diff:   {\n#             ...\n#         -   c: 3,\n#         +   c: 0,\n#           }\n```","summary":"<p>The same as <code>.eq</code>, but print readable diff report if actual not equals <em>value</em> (<code>!=</code>).</p>","abstract":false,"args":[{"name":"value","doc":null,"default_value":"","external_name":"value","restriction":""}],"args_string":"(value)","args_html":"(value)","location":{"filename":"src/assert-diff/assert.cr","line_number":18,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/assert.cr#L18"},"def":{"name":"eq_diff","args":[{"name":"value","doc":null,"default_value":"","external_name":"value","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"AssertDiff::EqualDiffExpectation.new(value, true)"}},{"id":"eq_diff_full(value)-class-method","html_id":"eq_diff_full(value)-class-method","name":"eq_diff_full","doc":"The same as `.eq_diff`, but this print full diff report.\n\n```\nx = {a: 1, b: 2, c: 0}\ny = {a: 1, b: 2, c: 3}\n\nx.should eq_diff_full y\n\n# =>\n# Expected: {a: 1, b: 2, c: 3}\n#      got: {a: 1, b: 2, c: 0}\n#     diff:   {\n#             a: 1,\n#             b: 2,\n#         -   c: 3,\n#         +   c: 0,\n#           }\n```","summary":"<p>The same as <code><a href=\"toplevel.html#eq_diff(value)-class-method\">.eq_diff</a></code>, but this print full diff report.</p>","abstract":false,"args":[{"name":"value","doc":null,"default_value":"","external_name":"value","restriction":""}],"args_string":"(value)","args_html":"(value)","location":{"filename":"src/assert-diff/assert.cr","line_number":40,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/assert.cr#L40"},"def":{"name":"eq_diff_full","args":[{"name":"value","doc":null,"default_value":"","external_name":"value","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"AssertDiff::EqualDiffExpectation.new(value, false)"}},{"id":"print_diff(before,after,io:IO=STDOUT)-class-method","html_id":"print_diff(before,after,io:IO=STDOUT)-class-method","name":"print_diff","doc":"Print diff to *io*.\n\nConsecutive no-changed are ommited like \"...\".\nUse `.assert_diff_full` if you need full-report.\n\n```\na = Rectangle.new(Point.new(0, 0), 4, 3)\nb = Rectangle.new(Point.new(0, 1), 4, 7)\nprint_diff(a, b)\n# =>\n#   {\n# -   height: 3,\n# +   height: 7,\n#     origin: {\n#       ...\n# -     y: 0,\n# +     y: 1,\n#     },\n#     ...\n#   }\n```","summary":"<p>Print diff to <em>io</em>.</p>","abstract":false,"args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":""},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":""},{"name":"io","doc":null,"default_value":"STDOUT","external_name":"io","restriction":"IO"}],"args_string":"(before, after, io : IO = <span class=\"t\">STDOUT</span>)","args_html":"(before, after, io : IO = <span class=\"t\">STDOUT</span>)","location":{"filename":"src/assert-diff/methods.cr","line_number":24,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/methods.cr#L24"},"def":{"name":"print_diff","args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":""},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":""},{"name":"io","doc":null,"default_value":"STDOUT","external_name":"io","restriction":"IO"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"print_diff_to_io(before, after, true, io)"}},{"id":"print_diff_full(before,after,io:IO=STDOUT)-class-method","html_id":"print_diff_full(before,after,io:IO=STDOUT)-class-method","name":"print_diff_full","doc":"Print full diff to *io*.\n\n```\na = Rectangle.new(Point.new(0, 0), 4, 3)\nb = Rectangle.new(Point.new(0, 1), 4, 7)\nprint_diff_full(a, b)\n# =>\n# {\n# -   height: 3,\n# +   height: 7,\n#     origin: {\n#       x: 0,\n# -     y: 0,\n# +     y: 1,\n#     },\n#     width: 4,\n# }\n```","summary":"<p>Print full diff to <em>io</em>.</p>","abstract":false,"args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":""},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":""},{"name":"io","doc":null,"default_value":"STDOUT","external_name":"io","restriction":"IO"}],"args_string":"(before, after, io : IO = <span class=\"t\">STDOUT</span>)","args_html":"(before, after, io : IO = <span class=\"t\">STDOUT</span>)","location":{"filename":"src/assert-diff/methods.cr","line_number":46,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/methods.cr#L46"},"def":{"name":"print_diff_full","args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":""},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":""},{"name":"io","doc":null,"default_value":"STDOUT","external_name":"io","restriction":"IO"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"print_diff_to_io(before, after, false, io)"}}],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"assert-diff/Float32","path":"Float32.html","kind":"struct","full_name":"Float32","name":"Float32","abstract":false,"superclass":{"html_id":"assert-diff/Float","kind":"struct","full_name":"Float","name":"Float"},"ancestors":[{"html_id":"assert-diff/Float","kind":"struct","full_name":"Float","name":"Float"},{"html_id":"assert-diff/Number","kind":"struct","full_name":"Number","name":"Number"},{"html_id":"assert-diff/Comparable","kind":"module","full_name":"Comparable","name":"Comparable"},{"html_id":"assert-diff/Value","kind":"struct","full_name":"Value","name":"Value"},{"html_id":"assert-diff/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/assert-diff/object-extension.cr","line_number":73,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/object-extension.cr#L73"}],"repository_name":"assert-diff","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[{"id":"__to_json_any:AnyHash-instance-method","html_id":"__to_json_any:AnyHash-instance-method","name":"__to_json_any","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : AnyHash","args_html":" : AnyHash","location":{"filename":"src/assert-diff/object-extension.cr","line_number":74,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/object-extension.cr#L74"},"def":{"name":"__to_json_any","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"AnyHash","visibility":"Public","body":"AnyHash.new(self)"}}],"macros":[],"types":[]},{"html_id":"assert-diff/Float64","path":"Float64.html","kind":"struct","full_name":"Float64","name":"Float64","abstract":false,"superclass":{"html_id":"assert-diff/Float","kind":"struct","full_name":"Float","name":"Float"},"ancestors":[{"html_id":"assert-diff/Float","kind":"struct","full_name":"Float","name":"Float"},{"html_id":"assert-diff/Number","kind":"struct","full_name":"Number","name":"Number"},{"html_id":"assert-diff/Comparable","kind":"module","full_name":"Comparable","name":"Comparable"},{"html_id":"assert-diff/Value","kind":"struct","full_name":"Value","name":"Value"},{"html_id":"assert-diff/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/assert-diff/object-extension.cr","line_number":79,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/object-extension.cr#L79"}],"repository_name":"assert-diff","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[{"id":"__to_json_any:AnyHash-instance-method","html_id":"__to_json_any:AnyHash-instance-method","name":"__to_json_any","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : AnyHash","args_html":" : AnyHash","location":{"filename":"src/assert-diff/object-extension.cr","line_number":80,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/object-extension.cr#L80"},"def":{"name":"__to_json_any","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"AnyHash","visibility":"Public","body":"AnyHash.new(self)"}}],"macros":[],"types":[]},{"html_id":"assert-diff/Int64","path":"Int64.html","kind":"struct","full_name":"Int64","name":"Int64","abstract":false,"superclass":{"html_id":"assert-diff/Int","kind":"struct","full_name":"Int","name":"Int"},"ancestors":[{"html_id":"assert-diff/Int","kind":"struct","full_name":"Int","name":"Int"},{"html_id":"assert-diff/Number","kind":"struct","full_name":"Number","name":"Number"},{"html_id":"assert-diff/Comparable","kind":"module","full_name":"Comparable","name":"Comparable"},{"html_id":"assert-diff/Value","kind":"struct","full_name":"Value","name":"Value"},{"html_id":"assert-diff/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/assert-diff/object-extension.cr","line_number":67,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/object-extension.cr#L67"}],"repository_name":"assert-diff","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[{"id":"__to_json_any:AnyHash-instance-method","html_id":"__to_json_any:AnyHash-instance-method","name":"__to_json_any","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : AnyHash","args_html":" : AnyHash","location":{"filename":"src/assert-diff/object-extension.cr","line_number":68,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/object-extension.cr#L68"},"def":{"name":"__to_json_any","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"AnyHash","visibility":"Public","body":"AnyHash.new(self)"}}],"macros":[],"types":[]},{"html_id":"assert-diff/URI","path":"URI.html","kind":"class","full_name":"URI","name":"URI","abstract":false,"superclass":{"html_id":"assert-diff/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"assert-diff/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"assert-diff/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/assert-diff/object-extension.cr","line_number":150,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/object-extension.cr#L150"}],"repository_name":"assert-diff","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":"This class represents a URI reference as defined by [RFC 3986: Uniform Resource Identifier\n(URI): Generic Syntax](https://www.ietf.org/rfc/rfc3986.txt).\n\nThis class provides constructors for creating URI instances from\ntheir components or by parsing their string forms and methods for accessing the various\ncomponents of an instance.\n\nBasic example:\n\n```\nrequire \"uri\"\n\nuri = URI.parse \"http://foo.com/posts?id=30&limit=5#time=1305298413\"\n# => #<URI:0x1003f1e40 @scheme=\"http\", @host=\"foo.com\", @port=nil, @path=\"/posts\", @query=\"id=30&limit=5\", ... >\nuri.scheme # => \"http\"\nuri.host   # => \"foo.com\"\nuri.query  # => \"id=30&limit=5\"\nuri.to_s   # => \"http://foo.com/posts?id=30&limit=5#time=1305298413\"\n```\n\n## Resolution and Relativization\n\n*Resolution* is the process of resolving one URI against another, *base* URI.\nThe resulting URI is constructed from components of both URIs in the manner specified by\n[RFC 3986 section 5.2](https://tools.ietf.org/html/rfc3986#section-5.2.2), taking components\nfrom the base URI for those not specified in the original.\nFor hierarchical URIs, the path of the original is resolved against the path of the base\nand then normalized. See `#resolve` for examples.\n\n*Relativization* is the inverse of resolution as that it procures an URI that\nresolves to the original when resolved against the base.\n\nFor normalized URIs, the following is true:\n\n```\na.relativize(a.resolve(b)) # => b\na.resolve(a.relativize(b)) # => b\n```\n\nThis operation is often useful when constructing a document containing URIs that must\nbe made relative to the base URI of the document wherever possible.\n\n# URL Encoding\n\nThis class provides a number of methods for encoding and decoding strings using\nURL Encoding (also known as Percent Encoding) as defined in [RFC 3986](https://www.ietf.org/rfc/rfc3986.txt)\nas well as [`x-www-form-urlencoded`](https://url.spec.whatwg.org/#urlencoded-serializing).\n\nEach method has two variants, one returns a string, the other writes directly\nto an IO.\n\n* `.decode(string : String, *, plus_to_space : Bool = false) : String`: Decodes a URL-encoded string.\n* `.decode(string : String, io : IO, *, plus_to_space : Bool = false) : Nil`: Decodes a URL-encoded string to an IO.\n* `.encode(string : String, *, space_to_plus : Bool = false) : String`: URL-encodes a string.\n* `.encode(string : String, io : IO, *, space_to_plus : Bool = false) : Nil`: URL-encodes a string to an IO.\n* `.decode_www_form(string : String, *, plus_to_space : Bool = true) : String`: Decodes an `x-www-form-urlencoded` string component.\n* `.decode_www_form(string : String, io : IO, *, plus_to_space : Bool = true) : Nil`: Decodes an `x-www-form-urlencoded` string component to an IO.\n* `.encode_www_form(string : String, *, space_to_plus : Bool = true) : String`: Encodes a string as a `x-www-form-urlencoded` component.\n* `.encode_www_form(string : String, io : IO, *, space_to_plus : Bool = true) : Nil`: Encodes a string as a `x-www-form-urlencoded` component to an IO.\n\nThe main difference is that `.encode_www_form` encodes reserved characters\n(see `.reserved?`), while `.encode` does not. The decode methods are\nidentical except for the handling of `+` characters.\n\nNOTE: `URI::Params` provides a higher-level API for handling `x-www-form-urlencoded`\nserialized data.","summary":"<p>This class represents a URI reference as defined by <a href=\"https://www.ietf.org/rfc/rfc3986.txt\">RFC 3986: Uniform Resource Identifier (URI): Generic Syntax</a>.</p>","class_methods":[],"constructors":[],"instance_methods":[{"id":"__to_json_any:AnyHash-instance-method","html_id":"__to_json_any:AnyHash-instance-method","name":"__to_json_any","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : AnyHash","args_html":" : AnyHash","location":{"filename":"src/assert-diff/object-extension.cr","line_number":151,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/77b0e01b41d70a34c95d599245b46d702695e6b2/src/assert-diff/object-extension.cr#L151"},"def":{"name":"__to_json_any","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"AnyHash","visibility":"Public","body":"AnyHash.new(self)"}}],"macros":[],"types":[]}]}})