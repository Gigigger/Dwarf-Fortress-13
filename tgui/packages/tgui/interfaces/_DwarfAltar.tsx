import { BlockQuote, Box, Button, Icon, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const _DwarfAltar = (props) => {
  const { act, data } = useBackend();
  const {
    favor,
    rituals,
  } = data as any;
  return (
    <Window theme="dwarf">
      <Box textAlign="center">
        Armok favor {favor}
      </Box>
      <Stack vertical>
        {rituals.map(rite => (
          <Stack.Item key={rite}>
            <Section
              title={rite.name}
              buttons={(
                <Button
                  textColor="white"
                  disabled={favor < rite.cost}
                  color="transparent"
                  icon="arrow-right"
                  onClick={() => act('perform_rite', {
                    path: rite.path,
                    cost: rite.cost,
                  })} >
                  Start
                </Button>
              )} >
              <Box
                color={favor < rite.cost ? "red" : "green"}
                mb={0.5}>
                <Icon name="star" /> Price {rite.cost}.
              </Box>
              <BlockQuote>
                {rite.desc}
              </BlockQuote>
            </Section>
          </Stack.Item>
        ))}
      </Stack>
    </Window>
  );
};
