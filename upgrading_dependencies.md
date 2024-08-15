# Dependencies upgrade instructions

## Rails

Remember to upgrade `load_defaults`

## Bundler

`bundle update --bundler`

## Audited
(https://github.com/collectiveidea/audited?tab=readme-ov-file#upgrading)

```
$ rails generate audited:upgrade
$ rake db:migrate
```
