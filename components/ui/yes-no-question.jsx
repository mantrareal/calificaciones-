'use client'

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'

export function YesNoQuestion({ title, answer, onAnswerChange, readonly = false }) {
  return (
    <Card className="w-full">
      <CardHeader className="pb-3">
        <CardTitle className="text-sm font-medium text-gray-700">
          {title}
        </CardTitle>
      </CardHeader>
      <CardContent className="pt-0">
        <div className="flex gap-2">
          <Button
            type="button"
            variant={answer === true ? 'default' : 'outline'}
            onClick={() => !readonly && onAnswerChange(true)}
            disabled={readonly}
            className="flex-1"
          >
            Sí
          </Button>
          <Button
            type="button"
            variant={answer === false ? 'default' : 'outline'}
            onClick={() => !readonly && onAnswerChange(false)}
            disabled={readonly}
            className="flex-1"
          >
            No
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}