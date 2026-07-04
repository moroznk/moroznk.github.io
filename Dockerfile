FROM jekyll/jekyll:3.8

WORKDIR /srv/jekyll/site
COPY site/Gemfile .
RUN chmod -R 777 /srv/jekyll/site; \
    bundle install
COPY site /srv/jekyll/site
RUN chmod -R 777 /srv/jekyll/site
CMD jekyll serve
