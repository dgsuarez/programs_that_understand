Programs that understand programs that write programs
=====================================================

Here's a small example set for metaprogramming in crystal and ruby.

We'll start by creating value objects in both
[crystal](code/crystal/value_object.html) and [ruby](code/ruby/value_object.html).

What about some class factory action? Again,
[crystal](code/crystal/db_adapters.html) and [ruby](code/ruby/db_adapters.html).

Fun right? Let's see another comparison. This time it's the visitor pattern.
The [crystal version](code/crystal/visitor.html) doesn't need any meta stuff, but the
[ruby one](code/ruby/visitor.html) does.

Finally, a couple of slightly bigger examples, a [state
machine](code/crystal/state_machine.html) in crystal, and a [validation
engine](code/ruby/validation.html) in ruby.

If you want to dig deeper you can read about [metaclasses in
ruby](https://viewsourcecode.org/why/hacking/seeingMetaclassesClearly.html),
and check out the docs for [crystal
macros](https://crystal-lang.org/docs/syntax_and_semantics/macros.html). You
can also check the actual source for the examples in the [github
repo](https://github.com/dgsuarez/programs_that_understand) for this site.
