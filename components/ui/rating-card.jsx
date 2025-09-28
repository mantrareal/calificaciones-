import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { StarRating } from './star-rating'

export function RatingCard({ title, rating, onRatingChange, readonly = false }) {
  return (
    <Card className="w-full">
      <CardHeader className="pb-3">
        <CardTitle className="text-sm font-medium text-gray-700">
          {title}
        </CardTitle>
      </CardHeader>
      <CardContent className="pt-0">
        <StarRating
          rating={rating}
          onRatingChange={onRatingChange}
          readonly={readonly}
        />
      </CardContent>
    </Card>
  )
}