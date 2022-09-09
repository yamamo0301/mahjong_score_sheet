class Form::ScoreCollection < Form::Base
  FORM_COUNT = 1
  # クラス外部からインスタンス変数への読み書きを可能にするために記述。
  attr_accessor :scores

  # score_collection_paramsがnilだった場合困るので、「= {}」として初期化。
  # score_collection_paramsに値が入っていた場合は、「= {}」は無視される。
  def initialize(attributes = {})
    super attributes
    # FORM_COUNTが持つ数値から順に-1しつつ配列に代入しScore.newを与えてあげる。（self = Form::ScoreCollection）
    # unless~present?を使用して値が存在する場合はfalseを返してあげる。（Form::ScoreCollection.new(…)としたい為）
    self.scores = FORM_COUNT.times.map { Score.new() } unless self.scores.present?
  end

  # 上でsuper attributesとしているので必要。
  def scores_attributes=(attributes)
    # 配列においてキーの値をScore.newに引数として渡す。
    self.scores = attributes.map { |_, v| Score.new(v) }
  end

  def save
    # transaction do以降の処理の中１つが失敗した場合、SQL処理を全部ロールバックするためにtransactionを使用。
    Score.transaction do
      # scores内の配列１つ１つに渡されていた値をsave!していく。
      self.scores.map(&:save!)
    end
      return true
    # save!を使用したためtrueではない場合recue節へ。
    # ActiveRecord::RecordInvalidオブジェクトをeへ。
    rescue => e
      return false
  end
end