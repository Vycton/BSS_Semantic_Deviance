import csv
scores = {}
with open('annotations.csv', newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter=',', quotechar='|')
    s = True
    for row in reader:
        if s:
            s = False
            continue
        an1 = row[5]
        an2 = row[6]

        if not an1 in scores:
            scores[an1] = [0,1]
        if not an2 in scores:
            scores[an2] = [0,1]

        if int(row[4]) == 1:
            scores[an1][0] += 1
        else:
            scores[an2][0] += 1

        scores[an1][1] += 1
        scores[an2][1] += 1

result = [[k, e[0]/e[1]] for k, e in scores.items()]
result.sort(key= lambda x: x[1])

with open('scores.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=',',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    writer.writerow(["phrase", "acceptability score"])
    for r in result:
        writer.writerow(r)
print(result)
