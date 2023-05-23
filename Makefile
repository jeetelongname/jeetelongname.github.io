##
# Website
#
# @file
# @version 0.1

build: webring
	cd blog-hugo; hugo

server: webring
	cd blog-hugo; hugo server -D

webring: openring
	./openring/openring -S ./blog-hugo/blogs.txt\
     < ./blog-hugo/openring.html\
     > ./blog-hugo/themes/manis-hugo-theme/layouts/partials/webring.html

openring:
	cd openring ; go build

# end
