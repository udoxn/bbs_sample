def valid_request?(query, keys)
    # 必要なキーがすべて含まれているかチェック
    keys_present = keys.all? { |key| query.key?(key) }

    # 各キーの値が空白でないかチェック
    values_valid = keys.all? { |key| !query[key].to_s.strip.empty? }

    # 両方の条件を満たしているか
    keys_present && values_valid
end