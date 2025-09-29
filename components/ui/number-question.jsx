'use client'

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'

export function NumberQuestion({ title, value, onValueChange, readonly = false }) {
  return (
    <Card className="w-full">
      <CardHeader className="pb-3">
        <CardTitle className="text-sm font-medium text-gray-700">
          {title}
        </CardTitle>
      </CardHeader>
      <CardContent className="pt-0">
        <Input
          type="number"
          value={value || ''}
          onChange={(e) => !readonly && onValueChange(parseInt(e.target.value) || 0)}
          disabled={readonly}
          placeholder="Ingresa un número"
          className="w-full"
        />
      </CardContent>
    </Card>
  )
}