crystal_doc_search_index_callback({"repository_name":"assert-diff","body":"# assert-diff\n\nAssert equals with readable diff report.\n\n![screenshot](https://github.com/YusukeHosonuma/assert-diff/raw/main/image/screenshot.png)\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   development_dependencies:\n     assert-diff:\n       github: YusukeHosonuma/assert-diff\n       branch: main\n   ```\n\n2. Run `shards install`\n\n## Example\n\nUse in specs:\n\n```crystal\nrequire \"assert-diff\"\n\ndescribe Rectangle do\n  it \"example\" do\n    actual = Rectangle.new(Point.new(0, 0), 4, 3, \"One\\nTwo\\nThree\")\n    expected = Rectangle.new(Point.new(0, 1), 4, 7, \"One\\nTwo\\nFour\")\n\n    actual.should eq_diff expected # or use `eq_full_diff`\n  end\nend\n```\n\nor use `assert_diff` and `assert_diff_full`.\n\n```crystal\nassert_diff(a, b)\nassert_diff_full(a, b)\n```\n\nUse to output:\n\n```crystal\nprint_diff(a, b)\nprint_diff_full(a, b)\n```\n\n## Contributing\n\nI don't think it can be used for edge cases.  \nIssues and PRs are welcome.\n\n1. Fork it (<https://github.com/YusukeHosonuma/assert-diff/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [Yusuke Hosonuma](https://github.com/YusukeHosonuma) - creator and maintainer\n","program":{"html_id":"assert-diff/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"superclass":null,"ancestors":[{"html_id":"assert-diff/Spec/Methods","kind":"module","full_name":"Spec::Methods","name":"Methods"},{"html_id":"assert-diff/Spec/Expectations","kind":"module","full_name":"Spec::Expectations","name":"Expectations"}],"locations":[],"repository_name":"assert-diff","program":true,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[{"html_id":"assert-diff/Spec/Expectations","kind":"module","full_name":"Spec::Expectations","name":"Expectations"},{"html_id":"assert-diff/Spec/Methods","kind":"module","full_name":"Spec::Methods","name":"Methods"}],"extended_modules":[{"html_id":"assert-diff/Spec/Expectations","kind":"module","full_name":"Spec::Expectations","name":"Expectations"},{"html_id":"assert-diff/Spec/Methods","kind":"module","full_name":"Spec::Methods","name":"Methods"}],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[{"id":"assert_diff(before:A,after:B,file=__FILE__,line=__LINE__)forallA,B-class-method","html_id":"assert_diff(before:A,after:B,file=__FILE__,line=__LINE__)forallA,B-class-method","name":"assert_diff","doc":"The same as `.eq_diff`, but this can be used independently.\n\n```\nassert_diff(x, y)\n```","summary":"<p>The same as <code><a href=\"toplevel.html#eq_diff(value)-class-method\">.eq_diff</a></code>, but this can be used independently.</p>","abstract":false,"args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":"A"},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":"B"},{"name":"file","doc":null,"default_value":"__FILE__","external_name":"file","restriction":""},{"name":"line","doc":null,"default_value":"__LINE__","external_name":"line","restriction":""}],"args_string":"(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B","args_html":"(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B","location":{"filename":"src/assert-diff/assert.cr","line_number":49,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/06452d60a8f31d602884025df123b86af989c6db/src/assert-diff/assert.cr#L49"},"def":{"name":"assert_diff","args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":"A"},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":"B"},{"name":"file","doc":null,"default_value":"__FILE__","external_name":"file","restriction":""},{"name":"line","doc":null,"default_value":"__LINE__","external_name":"line","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"assert_diff_internal(before, after, file, line, true)"}},{"id":"assert_diff_full(before:A,after:B,file=__FILE__,line=__LINE__)forallA,B-class-method","html_id":"assert_diff_full(before:A,after:B,file=__FILE__,line=__LINE__)forallA,B-class-method","name":"assert_diff_full","doc":"The same as `.eq_diff_full`, but this can be used independently.\n\n```\nassert_diff_full(x, y)\n```","summary":"<p>The same as <code><a href=\"toplevel.html#eq_diff_full(value)-class-method\">.eq_diff_full</a></code>, but this can be used independently.</p>","abstract":false,"args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":"A"},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":"B"},{"name":"file","doc":null,"default_value":"__FILE__","external_name":"file","restriction":""},{"name":"line","doc":null,"default_value":"__LINE__","external_name":"line","restriction":""}],"args_string":"(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B","args_html":"(before : A, after : B, file = __FILE__, line = __LINE__) forall A, B","location":{"filename":"src/assert-diff/assert.cr","line_number":58,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/06452d60a8f31d602884025df123b86af989c6db/src/assert-diff/assert.cr#L58"},"def":{"name":"assert_diff_full","args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":"A"},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":"B"},{"name":"file","doc":null,"default_value":"__FILE__","external_name":"file","restriction":""},{"name":"line","doc":null,"default_value":"__LINE__","external_name":"line","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"assert_diff_internal(before, after, file, line, false)"}},{"id":"eq_diff(value)-class-method","html_id":"eq_diff(value)-class-method","name":"eq_diff","doc":"The same as `.eq`, but print readable diff report if actual not equals *value* (`!=`).\n\n```\nx = {a: 1, b: 2, c: 0}\ny = {a: 1, b: 2, c: 3}\n\nx.should eq_diff y\n\n# =>\n# Expected: {a: 1, b: 2, c: 3}\n#      got: {a: 1, b: 2, c: 0}\n#     diff:   {\n#             ...\n#         -   c: 3,\n#         +   c: 0,\n#           }\n```","summary":"<p>The same as <code>.eq</code>, but print readable diff report if actual not equals <em>value</em> (<code>!=</code>).</p>","abstract":false,"args":[{"name":"value","doc":null,"default_value":"","external_name":"value","restriction":""}],"args_string":"(value)","args_html":"(value)","location":{"filename":"src/assert-diff/assert.cr","line_number":18,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/06452d60a8f31d602884025df123b86af989c6db/src/assert-diff/assert.cr#L18"},"def":{"name":"eq_diff","args":[{"name":"value","doc":null,"default_value":"","external_name":"value","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"AssertDiff::EqualDiffExpectation.new(value, true)"}},{"id":"eq_diff_full(value)-class-method","html_id":"eq_diff_full(value)-class-method","name":"eq_diff_full","doc":"The same as `.eq_diff`, but this print full diff report.\n\n```\nx = {a: 1, b: 2, c: 0}\ny = {a: 1, b: 2, c: 3}\n\nx.should eq_diff_full y\n\n# =>\n# Expected: {a: 1, b: 2, c: 3}\n#      got: {a: 1, b: 2, c: 0}\n#     diff:   {\n#             a: 1,\n#             b: 2,\n#         -   c: 3,\n#         +   c: 0,\n#           }\n```","summary":"<p>The same as <code><a href=\"toplevel.html#eq_diff(value)-class-method\">.eq_diff</a></code>, but this print full diff report.</p>","abstract":false,"args":[{"name":"value","doc":null,"default_value":"","external_name":"value","restriction":""}],"args_string":"(value)","args_html":"(value)","location":{"filename":"src/assert-diff/assert.cr","line_number":40,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/06452d60a8f31d602884025df123b86af989c6db/src/assert-diff/assert.cr#L40"},"def":{"name":"eq_diff_full","args":[{"name":"value","doc":null,"default_value":"","external_name":"value","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"AssertDiff::EqualDiffExpectation.new(value, false)"}},{"id":"print_diff(before,after,io:IO=STDOUT)-class-method","html_id":"print_diff(before,after,io:IO=STDOUT)-class-method","name":"print_diff","doc":"Print diff to *io*.\n\nConsecutive no-changed are ommited like \"...\".\nUse `.assert_diff_full` if you need full-report.\n\n```\na = Rectangle.new(Point.new(0, 0), 4, 3)\nb = Rectangle.new(Point.new(0, 1), 4, 7)\nprint_diff(a, b)\n# =>\n#   {\n# -   height: 3,\n# +   height: 7,\n#     origin: {\n#       ...\n# -     y: 0,\n# +     y: 1,\n#     },\n#     ...\n#   }\n```","summary":"<p>Print diff to <em>io</em>.</p>","abstract":false,"args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":""},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":""},{"name":"io","doc":null,"default_value":"STDOUT","external_name":"io","restriction":"IO"}],"args_string":"(before, after, io : IO = <span class=\"t\">STDOUT</span>)","args_html":"(before, after, io : IO = <span class=\"t\">STDOUT</span>)","location":{"filename":"src/assert-diff/methods.cr","line_number":24,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/06452d60a8f31d602884025df123b86af989c6db/src/assert-diff/methods.cr#L24"},"def":{"name":"print_diff","args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":""},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":""},{"name":"io","doc":null,"default_value":"STDOUT","external_name":"io","restriction":"IO"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"print_diff_to_io(before, after, true, io)"}},{"id":"print_diff_full(before,after,io:IO=STDOUT)-class-method","html_id":"print_diff_full(before,after,io:IO=STDOUT)-class-method","name":"print_diff_full","doc":"Print full diff to *io*.\n\n```\na = Rectangle.new(Point.new(0, 0), 4, 3)\nb = Rectangle.new(Point.new(0, 1), 4, 7)\nprint_diff_full(a, b)\n# =>\n# {\n# -   height: 3,\n# +   height: 7,\n#     origin: {\n#       x: 0,\n# -     y: 0,\n# +     y: 1,\n#     },\n#     width: 4,\n# }\n```","summary":"<p>Print full diff to <em>io</em>.</p>","abstract":false,"args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":""},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":""},{"name":"io","doc":null,"default_value":"STDOUT","external_name":"io","restriction":"IO"}],"args_string":"(before, after, io : IO = <span class=\"t\">STDOUT</span>)","args_html":"(before, after, io : IO = <span class=\"t\">STDOUT</span>)","location":{"filename":"src/assert-diff/methods.cr","line_number":46,"url":"https://github.com/YusukeHosonuma/assert-diff/blob/06452d60a8f31d602884025df123b86af989c6db/src/assert-diff/methods.cr#L46"},"def":{"name":"print_diff_full","args":[{"name":"before","doc":null,"default_value":"","external_name":"before","restriction":""},{"name":"after","doc":null,"default_value":"","external_name":"after","restriction":""},{"name":"io","doc":null,"default_value":"STDOUT","external_name":"io","restriction":"IO"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"print_diff_to_io(before, after, false, io)"}}],"constructors":[],"instance_methods":[],"macros":[],"types":[]}})