# :nocov:
module PgEngine
  module Utils
    class ResourceReports
      def check_invalid_records
        invalids = []
        classes.each do |klass|
          klass.find_each do |record|
            invalids << record unless record.valid?
          end
        end
        invalids.map do |r|
          [
            (r.account.to_s if r.respond_to?(:account)),
            r.class.to_s,
            r.id,
            r.errors.full_messages
          ]
        end
      end

      def report(klass)
        if klass.respond_to?(:discarded)
          <<~STRING
            #{klass}.unscoped.count: #{klass.unscoped.count}
            #{klass}.unscoped.kept.count: #{klass.unscoped.kept.count}
            #{klass}.unscoped.unkept.count: #{klass.unscoped.unkept.count}
            #{klass}.unscoped.discarded.count: #{klass.unscoped.discarded.count}
            #{klass}.unscoped.undiscarded.count: #{klass.unscoped.undiscarded.count}
          STRING
        else
          <<~STRING
            #{klass}.unscoped.count: #{klass.unscoped.count}
          STRING
        end
      end

      def report_all
        classes.map { |klass| report(klass).to_s }.join("\n")
      end

      def classes
        all = ActiveRecord::Base.descendants.select { |m| m.table_name.present? }
        all - ignored_classes
      end

      def ignored_classes
        [
          ActionText::Record,
          ActionMailbox::Record,
          ActiveStorage::Record,
          PgEngine::BaseRecord,
          Audited::Audit,
          ActionText::RichText,
          ActionText::EncryptedRichText,
          ActionMailbox::InboundEmail,
          ActiveStorage::VariantRecord,
          ActiveStorage::Attachment,
          ActiveStorage::Blob,
          ApplicationRecord
        ]
      end
    end
  end
end
# :nocov:
